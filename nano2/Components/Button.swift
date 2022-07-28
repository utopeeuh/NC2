//
//  Button.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 27/07/22.
//

import UIKit

class Button: UIButton {

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
    
    override var isEnabled: Bool {
        didSet {
            if(!isEnabled){
                backgroundColor = .systemGray3
                layer.borderWidth = 0
            }else{
                backgroundColor = .systemBlue
                layer.borderWidth = 1
            }
        }
    }
    func initialize(){
        backgroundColor = .systemBlue
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        
        setTitleColor(.systemGray, for: .disabled)
    }
    
    func invert(){
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemBlue.cgColor
        backgroundColor = .systemBackground
        setTitleColor(.systemBlue, for: .normal)
    }

}
