//
//  TaskCell.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit
import SnapKit

class TaskCell: UITableViewCell{
    
    var titleLabel = UILabel()
    var progressLabel = UILabel()
    var textStack = UIStackView()
    
    var editButton = TaskButton()
    
    var progressStack = UIStackView()
    var minProgressButton = TaskButton()
    var addProgressButton = TaskButton()
    
    var manageButton = TaskButton()
    
    var cellStack = UIStackView()
    var cellColor : UIColor?
    
    private var cellState = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        // Configure Components
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 1
        contentView.alpha = 0
    
        // fade in
        UIView.animate(withDuration: 1, animations: { self.contentView.alpha = 1 })
        
        titleLabel.font = UIFont.systemFont(ofSize: K.FontSize.md, weight: .medium)
        progressLabel.font = UIFont.systemFont(ofSize: K.FontSize.sm, weight: .regular)
        
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.distribution = .equalCentering

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(progressLabel)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        cellStack.axis = .horizontal
        cellStack.alignment = .center
        cellStack.distribution = .equalSpacing
        
        cellStack.addArrangedSubview(textStack)
        
        // Add subviews
        self.contentView.addSubview(cellStack)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellStack.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.contentView)
            make.trailing.equalTo(self.contentView).offset(-K.Offset.md)
            make.leading.equalTo(self.contentView).offset(K.Offset.md)
        }
    }
    
    func setState(_ cellState: Int){
        self.cellState = cellState
        cellStack.addArrangedSubview(getCellButton())
    }
    
    func getCellButton() -> UIView{
        switch(cellState){
        case K.State.isCreating:
            editButton.setTitle("Edit", for: .normal)
            editButton.snp.makeConstraints { make in
                make.width.equalTo(70)
            }
            return editButton
            
        case K.State.isEditing:
            progressStack.axis = .horizontal
            progressStack.alignment = .fill
            progressStack.distribution = .equalSpacing
            
//            minProgressButton.setImage(UIImage.init(systemName: "chevron.left"), for: .normal)
//            addProgressButton.setImage(UIImage.init(systemName: "chevron.right"), for: .normal)
            
            minProgressButton.setTitle("<", for: .normal)
            addProgressButton.setTitle(">", for: .normal)
            
            minProgressButton.snp.makeConstraints { make in
                make.width.equalTo(30)
            }
            
            addProgressButton.snp.makeConstraints { make in
                make.width.equalTo(30)
            }

            progressStack.addArrangedSubview(minProgressButton)
            progressStack.addArrangedSubview(addProgressButton)
            progressStack.translatesAutoresizingMaskIntoConstraints = false
            
            return progressStack
            
        default:
            manageButton.setTitle("Manage", for: .normal)
            manageButton.snp.makeConstraints { make in
                make.width.equalTo(100)
            }
            return manageButton
        }
    }
}
