//
//  AuthTextField.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 23/07/22.
//

import UIKit

class Textfield: UITextField {
    
    var height: Double!
    
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

    func initialize() {
        self.frame.size = CGSize(width: 0, height: 60)
        height = 60
    }
    
    func setText(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        print("Height: \(self.frame.height), Width: \(self.frame.width)")
        bottomLine.frame = CGRect(x: 0, y: height - Double(K.Offset.lg), width: UIScreen.main.bounds.width-Double(K.Offset.width), height: 1)
        bottomLine.backgroundColor = UIColor.red.cgColor
    
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}
