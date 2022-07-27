//
//  AddTaskVC.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import UIKit

class AddTaskVC: UIViewController, VCConfig{

    private var vstack = UIStackView()
    private var titleLabel = TextFieldLabel()
    private var titleField = Textfield()
    private var goalsLabel = TextFieldLabel()
    private var goalsField = Textfield()
    private var progressLabel = TextFieldLabel()
    private var progressDropDown = DropDown()
    private var saveButton = Button()
    
    private var selectedProgress = 0
    
    public var completion: ((Task) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create a skill"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    
        configureComponents()
        configureLayout()
    }
    
    func configureComponents() {
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.sm
        
        titleLabel.setText("title")
        titleField.setText("What skill do you want to learn?")
        titleField.addBottomBorder()
        
        goalsLabel.setText("goals")
        goalsField.setText("What do you want to accomplish with this?")
        goalsField.addBottomBorder()
        
        progressLabel.setText("progress")
        progressDropDown.text = "Not Started"
        progressDropDown.optionArray = [
            "Not Started", "Preview", "Question", "Read", "Reflect", "Recite", "Review", ]
        
        progressDropDown.optionIds = [
            K.StatusTask.notStarted,
            K.StatusTask.preview,
            K.StatusTask.question,
            K.StatusTask.read,
            K.StatusTask.reflect,
            K.StatusTask.recite,
            K.StatusTask.review,
            K.StatusTask.done
        ]
        
        progressDropDown.didSelect{(selectedText, index ,id) in
            self.selectedProgress = id
        }
        
        progressDropDown.selectedIndex = 0
        progressDropDown.addBottomBorder()
        
        saveButton.setTitle("Add skill", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        vstack.addArrangedSubview(titleLabel)
        vstack.addArrangedSubview(titleField)
        vstack.addArrangedSubview(goalsLabel)
        vstack.addArrangedSubview(goalsField)
        vstack.addArrangedSubview(progressLabel)
        vstack.addArrangedSubview(progressDropDown)
        vstack.addArrangedSubview(getEmptyView())
        vstack.addArrangedSubview(saveButton)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        vstack.setCustomSpacing(K.Spacing.lg, after: titleField)
        vstack.setCustomSpacing(K.Spacing.lg, after: goalsField)
        vstack.setCustomSpacing(K.Spacing.lg, after: progressDropDown)
    }
    
    func configureLayout() {
        view.addSubview(vstack)

        vstack.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
        }
    }
    
    @objc func saveButtonTapped(){
        
        if(titleField.text?.isEmpty == false && goalsField.text?.isEmpty == false){
            let title = titleField.text!
            let goals = goalsField.text!
            
            let newTask = Task(title, goals)
            self.navigationController?.popViewController(animated: true)
            completion!(newTask)
        }
    }
}
