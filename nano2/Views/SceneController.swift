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
    let tabBar : UITabBarController
    let homeVC : UIViewController
    
    init(){
        signupVC = SignUpVC()
        loginVC = LogInVC()
        tabBar = TabBarController()
        homeVC = HomeVC()

        tabBar.selectedIndex = 0
        tabBar.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
