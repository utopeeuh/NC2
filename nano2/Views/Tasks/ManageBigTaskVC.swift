//
//  ManageBigTask.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 28/07/22.
//

import Foundation
import UIKit

class ManageBigTaskVC : UIViewController, VCConfig, UITableViewDelegate, UITableViewDataSource {
    
    private var taskTable = UITableView()
    private var bigTaskLabel = UILabel()
    private var progressView = UIProgressView()
    private var progressLabel = UILabel()
    private var seperatorLabel = UILabel()
    private var finishButton = Button()
    private var vstack = UIStackView()
    private let cellIdentifier = "manageTaskCell"
    
    var currBigTask : BigTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Manage Plan"
        
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
    }
    
    func configureComponents() {
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.md
        
        bigTaskLabel.text = currBigTask.title
        bigTaskLabel.font = UIFont.systemFont(ofSize: K.FontSize.lg, weight: .bold)
        bigTaskLabel.textColor = .black
        
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 10
        progressView.subviews[1].clipsToBounds = true
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 2)
        
        seperatorLabel.text = "Skills"
        seperatorLabel.font = UIFont.systemFont(ofSize: K.FontSize.lg, weight: .bold)
        
        progressLabel.font = UIFont.systemFont(ofSize: K.FontSize.sm, weight: .regular)
        progressLabel.textAlignment = .left
        
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.backgroundColor = .white
        taskTable.register(TaskCell.self, forCellReuseIdentifier: cellIdentifier)
        
        finishButton.setTitle("Finish plan", for: .normal)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        
        setProgressBar()
        
        vstack.addArrangedSubview(bigTaskLabel)
        vstack.addArrangedSubview(progressView)
        vstack.addArrangedSubview(progressLabel)
        vstack.addArrangedSubview(seperatorLabel)
        vstack.addArrangedSubview(taskTable)
        vstack.addArrangedSubview(finishButton)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        let editPlanButton = UIBarButtonItem(title: "Edit plan", style: .plain, target: self, action: #selector(editPlanTapped))
        navigationItem.rightBarButtonItem = editPlanButton
    }
    
    func configureLayout() {
        view.addSubview(vstack)
        
        vstack.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
        }
        
        vstack.setCustomSpacing(K.Spacing.sm, after: bigTaskLabel)
        vstack.setCustomSpacing(K.Spacing.sm, after: progressView)
    }
    
    func setProgressBar(){
        progressView.progress = currBigTask.countProgressFloat()
        progressLabel.text = "\(currBigTask.countProgress()) Done"
        
        finishButton.isEnabled = currBigTask.countProgressFloat() == 1 ? true : false
    }
    
    @objc func finishButtonTapped(){
        // create the alert
        let alert = UIAlertController(title: "Are you sure?", message: "This is plan will be moved to your history", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (UIAlertAction)in
            // update firestore
            taskRepo.setDone(currBigTask)
            
            // update current data
            currentUser?.finishedTasks.append(currBigTask)
            let ongoingTasks = currentUser?.ongoingTasks
            for taskIndex in 0...ongoingTasks!.count-1{
                if ongoingTasks![taskIndex] == currBigTask{
                    currentUser?.ongoingTasks.remove(at: taskIndex)
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    @objc func editPlanTapped(_ sender: Any){
        let vc = AddBigTaskVC()
        vc.isEditingMode = true
        vc.taskEdit = currBigTask
        
        vc.editCompletion = { [self] in
            bigTaskLabel.text = currBigTask.title
            setProgressBar()
            taskTable.reloadData()
        }

        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Configure table view
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currBigTask.tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: taskTable.frame.size.width, height: 10))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskCell
        
        let currTask = currBigTask.tasks[(indexPath as NSIndexPath).section]
        cell.titleLabel.text = currTask.title
        cell.progressLabel.text = "Progress: \(convertStatus(currTask.status))"
        
        // Configure buttons
        cell.minProgressButton.addTarget(self, action: #selector(minProgressTapped), for: .touchUpInside)
        
        cell.addProgressButton.addTarget(self, action: #selector(addProgressTapped), for: .touchUpInside)
        
        cell.minProgressButton.task = currTask
        cell.minProgressButton.row = (indexPath as NSIndexPath).section
        cell.addProgressButton.task = currTask
        cell.addProgressButton.row = (indexPath as NSIndexPath).section
        
        cell.setState(K.State.isEditing)
        
        return cell
    }
    
    @objc func minProgressTapped(_ sender: TaskButton){
        // update firestore
        taskRepo.minProgress(sender.task!){ success in
            if (success){
                self.setProgressBar()
                self.setCellProgress(IndexPath(item: 0, section: sender.row!), task: sender.task!)
            }
        }
    }
    
    @objc func addProgressTapped(_ sender: TaskButton){
        taskRepo.addProgress(sender.task!){ success in
            if (success){
                self.setProgressBar()
                self.setCellProgress(IndexPath(item: 0, section: sender.row!), task: sender.task!)
            }
        }
    }
    
    func setCellProgress(_ indexPath: IndexPath, task: Task){
        let cell = self.taskTable.cellForRow(at: indexPath) as! TaskCell
        cell.progressLabel.text = "Progress: \(convertStatus((task.status)!)) "
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        taskTable.deselectRow(at: indexPath, animated: true)
    }
}

