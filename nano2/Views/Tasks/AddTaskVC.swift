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
    private var progressLabel = TextFieldLabel()
    private var progressDropDown = DropDown()
    private var saveButton = Button()
    
    private var selectedProgress = 0
    
    public var isEditingMode = false
    public var currTask : Task?
    public var completion: ((Task) -> Void)?
    public var editCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create a skill"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    
        configureComponents()
        configureLayout()
        
        configureEditing()
    }
    
    func configureComponents() {
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.sm
        
        titleLabel.setText("title")
        titleField.setText("What skill do you want to learn?")
        titleField.addBottomBorder()
        
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
        vstack.addArrangedSubview(progressLabel)
        vstack.addArrangedSubview(progressDropDown)
        vstack.addArrangedSubview(getEmptyView())
        vstack.addArrangedSubview(saveButton)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        vstack.setCustomSpacing(K.Spacing.lg, after: titleField)
        vstack.setCustomSpacing(K.Spacing.lg, after: progressDropDown)
    }
    
    func configureLayout() {
        view.addSubview(vstack)

        vstack.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
        }
    }
    
    func configureEditing(){
        title = "Edit Skill"
        titleField.text = currTask?.title
        progressDropDown.selectedIndex = currTask?.status
        selectedProgress = currTask?.status ?? 0
        saveButton.setTitle("Save", for: .normal)
    }

    @objc func saveButtonTapped(){
        
        if(titleField.text == ""){
            return
        }
        
        if(!isEditingMode){
            let title = titleField.text!
            let newTask = Task(title, selectedProgress)
            self.navigationController?.popViewController(animated: true)
            completion!(newTask)
        }
        else{
            currTask!.title = titleField.text!
            currTask!.status = selectedProgress
            self.navigationController?.popViewController(animated: true)
            editCompletion!()
        }
    }
}
