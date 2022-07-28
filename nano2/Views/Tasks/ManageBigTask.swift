//
//  ManageBigTask.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 28/07/22.
//

import Foundation
import UIKit

class ManageBigTask : UIViewController, VCConfig, UITableViewDelegate, UITableViewDataSource {
    
    private var taskTable = UITableView()
    private var userLabel = UILabel()
    private var seperatorLabel = UILabel()
    private var vstack = UIStackView()
    private let cellIdentifier = "manageTaskCell"
    
    var currBigTask : BigTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Manage Plan"
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
        
        showSpinner(onView: self.view)
        let group = DispatchGroup()
        group.enter()
        
        userRepo.fetchUser {
            group.leave()
        }
        
        group.notify(queue: .main){ [self] in
            removeSpinner()
            userLabel.text = "Welcome back, " + (currentUser?.username ?? "User")
            taskTable.reloadData()
        }
    }
    
    func configureComponents() {
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.md
        
        userLabel.font = UIFont.systemFont(ofSize: K.FontSize.lg, weight: .bold)
        userLabel.textColor = .black
        
        seperatorLabel.text = "Skills"
        seperatorLabel.font = UIFont.systemFont(ofSize: K.FontSize.md, weight: .medium)
        seperatorLabel.textColor = .black
        
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.backgroundColor = .white
        taskTable.register(TaskCell.self, forCellReuseIdentifier: cellIdentifier)
        
        vstack.addArrangedSubview(seperatorLabel)
        vstack.addArrangedSubview(taskTable)
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
        
    }

    @objc func editPlanTapped(_ sender: Any){
//        let vc = AddBigTaskVC()
//
//        vc.saveCompletion = {
//            self.bigTaskTable.reloadData()
//            print("Reloaded Table")
//        }
//
//        vc.hidesBottomBarWhenPushed = true;
//        self.navigationController?.pushViewController(vc, animated: true)
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
        let indexPath = IndexPath(item: 0, section: sender.row!)
        // update firestore
        taskRepo.minProgress(sender.task!){ success in
            if (success){
                self.taskTable.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    @objc func addProgressTapped(_ sender: TaskButton){
        let indexPath = IndexPath(item: 0, section: sender.row!)
        taskTable.reloadRows(at: [indexPath], with: .automatic)
        // update firestore
        taskRepo.addProgress(sender.task!){ success in
            if (success){
                self.taskTable.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        taskTable.deselectRow(at: indexPath, animated: true)
    }
}

