//
//  ViewController.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 22/07/22.
//

import UIKit
import SnapKit

class HomeVC: UIViewController, VCConfig,  UITableViewDelegate, UITableViewDataSource{
    
    private var bigTaskTable = UITableView()
    private var userLabel = UILabel()
    private var seperatorLabel = UILabel()
    private var vstack = UIStackView()
    private let cellIdentifier = "bigTaskCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureComponents()
        configureLayout()
        
        showSpinner(onView: self.view)
        let group = DispatchGroup()
        group.enter()
        
        userRepo.fetchUser {
            group.leave()
        }
        
        group.notify(queue: .main){ [self] in
            removeSpinner()
            userLabel.text = "Welcome back, " + (currentUser?.username ?? "User")
            bigTaskTable.reloadData()
        }
    }
    
    func configureComponents() {
        
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.spacing = K.Spacing.md
        
        userLabel.font = UIFont.systemFont(ofSize: K.FontSize.md, weight: .bold)
        userLabel.textColor = .black
        
        seperatorLabel.text = "Currently Learning"
        seperatorLabel.font = UIFont.systemFont(ofSize: K.FontSize.md, weight: .bold)
        seperatorLabel.textColor = .black
        
        bigTaskTable.delegate = self
        bigTaskTable.dataSource = self
        bigTaskTable.backgroundColor = .white
        bigTaskTable.register(TaskCell.self, forCellReuseIdentifier: cellIdentifier)
        
        vstack.addArrangedSubview(userLabel)
        vstack.addArrangedSubview(seperatorLabel)
        vstack.addArrangedSubview(bigTaskTable)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        let addBigTask = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addBigTaskTapped))
        navigationItem.rightBarButtonItem = addBigTask
    }
    
    func configureLayout() {
        view.addSubview(vstack)

        vstack.snp.makeConstraints{ (make) -> Void in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(K.Offset.md)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).offset(-K.Offset.md)
        }
        
    }

    @objc func addBigTaskTapped(_ sender: Any){
        let vc = AddBigTaskVC()
        
        vc.saveCompletion = {
            self.bigTaskTable.reloadData()
            print("Reloaded Table")
        }
        
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Configure table view
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser?.bigTasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bigTaskTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskCell
        
        let currBigTask = currentUser?.bigTasks ?? []
        cell.titleLabel.text = currBigTask[indexPath.row].title
        cell.progressLabel.text = currBigTask[indexPath.row].countProgress()
        cell.isBigTask = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

