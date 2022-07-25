//
//  AddLittleTaskVC.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import UIKit

class AddLittleTaskVC: UIViewController, VCConfig{

    var titleField: Textfield!
    var goalsField: Textfield!
    var saveButton: UIButton!
    
    public var completion: ((LittleTask) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        addComponents()
        configureLayout()
        configureComponents()
    }
    
    func addComponents() {
        titleField = Textfield()
        goalsField = Textfield()
        saveButton = UIButton()
        
        view.addSubview(titleField)
        view.addSubview(goalsField)
        view.addSubview(saveButton)
    }
    
    func configureLayout() {
        titleField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(K.Offset.topComponent)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-K.Offset.width)
        }
        
        goalsField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(titleField.snp.bottom).offset(K.Offset.lg)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-K.Offset.width)
        }
        
        saveButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(goalsField.snp.bottom).offset(K.Offset.lg)
            make.centerX.equalTo(view)
            make.width.equalTo(view).offset(-K.Offset.width)
        }
    }
    
    func configureComponents() {
        titleField.setText("Enter title")
        titleField.addBottomBorder()
        
        goalsField.setText("Enter goals")
        goalsField.addBottomBorder()
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .green
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped(){
        
        if(titleField.text?.isEmpty == false && goalsField.text?.isEmpty == false){
            let title = titleField.text!
            let goals = goalsField.text!
            
            let newLittleTask = LittleTask(title, goals)
            self.navigationController?.popViewController(animated: true)
            completion!(newLittleTask)
        }
    }
}
