//
//  EmptyView.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 27/07/22.
//

import Foundation
import UIKit

class EmptyView: UIView{
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
    }
}
