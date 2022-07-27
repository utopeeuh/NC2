//
//  TextFieldLabel.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 27/07/22.
//

import Foundation
import UIKit

class TextFieldLabel: UILabel{
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
        textAlignment = .left
        textColor = .systemGray
        font = UIFont.systemFont(ofSize: K.FontSize.sm, weight: .light)
    }
    
    func setText(_ text: String){
        self.text = text.uppercased()
    }
}
