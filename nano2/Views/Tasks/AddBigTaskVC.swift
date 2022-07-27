//
//  AddBigTaskVC.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 24/07/22.
//

import Foundation
import SnapKit
import UIKit

class AddBigTaskVC: UIViewController, VCConfig, UITableViewDelegate, UITableViewDataSource{
    
    private var bigTitleLabel = TextFieldLabel()
    private var bigTitle = Textfield()
    
    private var seperatorText = UILabel()
    private var seperatorStack = UIStackView()
    private var addRowButton = TextButton()
    
    private var taskDescLabel = UILabel()
    private var taskTable = UITableView()
    private var saveButton = Button()
    private var vstack = UIStackView()
    
    public var saveCompletion : (() -> Void)?
    
    private var tasks : [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create a plan"
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureComponents() {
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.sm
        
        bigTitleLabel.setText("title")

        bigTitle.setText("What do you want to learn?")
        bigTitle.addBottomBorder()
        
        seperatorStack.axis = .horizontal
        seperatorStack.alignment = .fill
        seperatorStack.distribution = .equalSpacing
        seperatorStack.translatesAutoresizingMaskIntoConstraints = false
        
        seperatorText.text = "Let's break it down"
        seperatorText.font = UIFont.systemFont(ofSize: K.FontSize.lg, weight: .bold)
        
        addRowButton.setTitle("Add skill", for: .normal)
        addRowButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        seperatorStack.addArrangedSubview(seperatorText)
        seperatorStack.addArrangedSubview(addRowButton)
        
        taskDescLabel.text = "For example, if your plan is to learn how to cook, then you can break it down into different skills like cutting, frying, etc."
        taskDescLabel.font = UIFont.systemFont(ofSize: K.FontSize.md, weight: .light)
        taskDescLabel.textColor = .systemGray2
        taskDescLabel.numberOfLines = 3
        taskDescLabel.lineBreakMode = .byWordWrapping
        taskDescLabel.sizeToFit()
        
        taskTable.backgroundColor = .white
        taskTable.dataSource = self
        taskTable.delegate = self
        taskTable.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        taskTable.separatorStyle = .none
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        vstack.addArrangedSubview(bigTitleLabel)
        vstack.addArrangedSubview(bigTitle)
        vstack.addArrangedSubview(seperatorStack)
        vstack.addArrangedSubview(taskDescLabel)
        vstack.addArrangedSubview(taskTable)
        vstack.addArrangedSubview(saveButton)
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        vstack.setCustomSpacing(K.Spacing.lg, after: bigTitle)
    }
    
    @objc func saveButtonTapped(){
        //save to firebase
        let newBigTask = BigTask(bigTitle.text!, tasks)
        taskRepo.createTask(newBigTask){
            self.saveCompletion?()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func configureLayout() {
        view.addSubview(vstack)
        vstack.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
        }
    }
    
    @objc func addTask(){
        let vc = AddTaskVC()

        vc.completion = {[self] newTask in
            tasks.append(newTask)
            taskTable.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Setup Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // if section has header text, bigger spacing
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: taskTable.frame.size.width, height: 10))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        let currTask = tasks[(indexPath as NSIndexPath).section]
        
        cell.titleLabel.text = currTask.title
        cell.progressLabel.text = "Current progress: \(convertStatus(currTask.status ?? 0))"
        cell.setState(K.State.isCreating)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        taskTable.deselectRow(at: indexPath, animated: true)
    }
}
