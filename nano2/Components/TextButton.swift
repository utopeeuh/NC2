//
//  TextButton.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 27/07/22.
//

import UIKit

class TextButton: UIButton {

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
        backgroundColor = .clear
        setTitleColor(.systemBlue, for: .normal)
    }
}
