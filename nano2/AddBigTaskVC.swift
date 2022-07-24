//
//  AddBigTaskVC.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 24/07/22.
//

import Foundation
import SnapKit
import UIKit

class AddBigTaskVC: UIViewController, VCConfig{
    
    var bigTitle: Textfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addComponents()
        configureLayout()
        configureComponents()
    }
    
    func addComponents() {
        bigTitle = Textfield()
        view.addSubview(bigTitle)
    }
    
    func configureLayout() {
        bigTitle.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view).offset(K.Offset.topComponent)
            make.width.equalTo(view).offset(-K.Offset.width)
            make.centerX.equalTo(view)
        }
    }
    
    func configureComponents() {
        bigTitle.setText("Enter big title")
        bigTitle.addBottomBorder()
    }
}
