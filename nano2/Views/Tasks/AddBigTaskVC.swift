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
    
    private var bigTitle = Textfield()
    private var addRowButton = UIButton()
    private var taskTable = UITableView()
    private var saveButton = UIButton()
    public var saveCompletion : (() -> Void)?
    
    private var tasks : [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureComponents() {
        bigTitle.setText("Enter big title")
        bigTitle.addBottomBorder()
        
        addRowButton.frame.size = CGSize(width: 100, height: 50)
        addRowButton.backgroundColor = .red
        addRowButton.setTitle("Add", for: .normal)
        addRowButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        
        taskTable.dataSource = self
        taskTable.delegate = self
        taskTable.backgroundColor = .white
        taskTable.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        
        saveButton.frame.size = CGSize(width: 100, height: 50)
        saveButton.backgroundColor = .red
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        view.addSubview(bigTitle)
        view.addSubview(addRowButton)
        view.addSubview(taskTable)
        view.addSubview(saveButton)
        
        bigTitle.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.width)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        addRowButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(bigTitle.snp.bottom).offset(K.Offset.lg)
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.width)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        taskTable.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(addRowButton.snp.bottom).offset(K.Offset.lg)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        saveButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(taskTable.snp.bottom).offset(K.Offset.lg)
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.width)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.lg)
        }
    }
    
    // MARK: - Setup Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.titleLabel.text = tasks[indexPath.row].title
        cell.progressLabel.text = "Current progress: \(convertStatus(tasks[indexPath.row].status ?? 0))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @objc func addTask(){
        let vc = AddTaskVC()

        vc.completion = {
            newTask in
            self.tasks.append(newTask)
            self.taskTable.delegate = self
            self.taskTable.dataSource = self
            self.taskTable.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
