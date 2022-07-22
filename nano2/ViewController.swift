//
//  ViewController.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 22/07/22.
//

import UIKit

class ViewController: UIViewController {

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Join us today in our fun and games!"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let momoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "momo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        momoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        momoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        momoImageView.widthAnchor.constraint(equalToConstant:200).isActive = true
        momoImageView.heightAnchor.constraint(equalToConstant:200).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: momoImageView.bottomAnchor, constant: 50).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }


}

