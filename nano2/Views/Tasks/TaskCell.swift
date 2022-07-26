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
    let vStack = UIStackView()
    var cellColor : UIColor?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure Components
        self.backgroundColor = .red
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        progressLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .leading
        vStack.spacing = 8

        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(progressLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        self.contentView.addSubview(vStack)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        vStack.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(K.Offset.md)
            make.trailing.equalTo(self).offset(-K.Offset.md)
        }
    }
    
    func setTask(_ task: Task){
        titleLabel.text = task.title
        progressLabel.text = "Current progress: \(convertStatus(task.status ?? 0))"
    }
}
