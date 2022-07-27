//
//  TabBarController.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 25/07/22.
//

import Foundation
import UIKit

class TabBarController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: HomeVC(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house")!),
            createNavController(for: SignUpVC(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.title = title
        
        return navController
    }
}
