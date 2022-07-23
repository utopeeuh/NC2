//
//  ViewController.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 22/07/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Join us today in our fun and games!"
        return textView
    }()
    
    let momoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "momo"))
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .yellow
    
        view.addSubview(momoImageView)
        view.addSubview(descriptionTextView)
        
        configure()
    }
    
    func configure(){
        
        momoImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(100)
            make.centerX.equalTo(view)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        descriptionTextView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(momoImageView.snp.bottom).offset(50)
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

}

