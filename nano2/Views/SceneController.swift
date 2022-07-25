//
//  SceneController.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 24/07/22.
//

import Foundation
import UIKit

let scene = SceneController()

class SceneController{
    
    let signupVC : UIViewController
    let loginVC : UIViewController
    let homeVC : UIViewController
    let addBigTaskVC : UIViewController
    
    init(){
        signupVC = SignUpVC()
        loginVC = LogInVC()
        homeVC = HomeVC()
        addBigTaskVC = AddBigTaskVC()
    }
}
