//
//  AuthTextField.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 23/07/22.
//

import UIKit

class AuthTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 197/255, green: 199/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        self.borderStyle = .none
        
        // Add the line to the text field
        self.layer.addSublayer(bottomLine)
    }
}
