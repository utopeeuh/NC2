//
//  GradientButton.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 23/07/22.
//

import UIKit

class GradientButton: UIButton {

    required init() {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 50
        self.frame.size = CGSize(width: 100, height: 50)
        self.backgroundColor = .clear
        
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255,  blue: 75/255, alpha: 1)]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.layer.masksToBounds = true;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
