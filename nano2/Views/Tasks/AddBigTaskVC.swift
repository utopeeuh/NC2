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
    
    var bigTitle = Textfield()
    var addRowButton = UIButton()
    var littleTaskTable = UITableView()
    var saveButton = UIButton()
    
    var littleTasks : [LittleTask] = []
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        addRowButton.addTarget(self, action: #selector(addLittleTask), for: .touchUpInside)
        
        littleTaskTable.dataSource = self
        littleTaskTable.delegate = self
        littleTaskTable.backgroundColor = .white
        littleTaskTable.register(LittleTaskCell.self, forCellReuseIdentifier: "littleTaskCell")
        
        saveButton.frame.size = CGSize(width: 100, height: 50)
        saveButton.backgroundColor = .red
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped(){
        //save to firebase
        
        // pop vc
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureLayout() {
        view.addSubview(bigTitle)
        view.addSubview(addRowButton)
        view.addSubview(littleTaskTable)
        view.addSubview(saveButton)
        
        bigTitle.snp.makeConstraints{(make) -> Void in
            make.top.equalToSuperview().offset(K.Offset.topComponent)
            make.width.equalToSuperview().offset(-K.Offset.width)
            make.centerX.equalToSuperview()
        }
        
        addRowButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(bigTitle.snp.bottom).offset(K.Offset.lg)
            make.width.equalToSuperview().offset(-K.Offset.width)
            make.centerX.equalToSuperview()
        }
        
        littleTaskTable.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(addRowButton.snp.bottom).offset(K.Offset.lg)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(littleTaskTable.snp.bottom).offset(K.Offset.lg)
            make.width.equalToSuperview().offset(-K.Offset.width)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-K.Offset.lg)
        }
    }
    
    // MARK: - Setup Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return littleTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = littleTaskTable.dequeueReusableCell(withIdentifier: "littleTaskCell", for: indexPath) as! LittleTaskCell
        
        cell.setTask(littleTasks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @objc func addLittleTask(){
        let vc = AddLittleTaskVC()

        vc.completion = {
            newTask in
            self.littleTasks.append(newTask)
            self.littleTaskTable.delegate = self
            self.littleTaskTable.dataSource = self
            self.littleTaskTable.reloadData()

            print(self.littleTasks.count)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
