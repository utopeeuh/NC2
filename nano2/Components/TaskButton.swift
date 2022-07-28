//
//  TaskButton.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 28/07/22.
//

import Foundation
import UIKit

class TaskButton : UIButton{
    
    var bigTask : BigTask?
    var task : Task?
    var row : Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    init() {
        super.init(frame: .zero)
        self.initialize()
    }
    
    func initialize(){
        backgroundColor = .systemBlue
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
    }
}
