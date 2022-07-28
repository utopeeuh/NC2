//
//  ViewController.swift
//  nano2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 22/07/22.
//

import UIKit
import SnapKit

class HomeVC: UIViewController, VCConfig,  UITableViewDelegate, UITableViewDataSource{
    
    public var bigTaskTable = UITableView()
    private var userLabel = UILabel()
    private var seperatorLabel = UILabel()
    private var vstack = UIStackView()
    private let cellIdentifier = "bigTaskCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        bigTaskTable.reloadData()
        print("ASDasdoijkhsandlasjdlakSjdklaSJda")
    }
    
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
        
        userLabel.font = UIFont.systemFont(ofSize: K.FontSize.lg, weight: .bold)
        userLabel.textColor = .black
        
        seperatorLabel.text = "Currently Learning"
        seperatorLabel.font = UIFont.systemFont(ofSize: K.FontSize.md, weight: .medium)
        seperatorLabel.textColor = .black
        
        bigTaskTable.delegate = self
        bigTaskTable.dataSource = self
        bigTaskTable.backgroundColor = .white
        bigTaskTable.register(TaskCell.self, forCellReuseIdentifier: cellIdentifier)
        
//        vstack.addArrangedSubview(userLabel)
        vstack.addArrangedSubview(seperatorLabel)
        vstack.addArrangedSubview(bigTaskTable)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        let addBigTask = UIBarButtonItem(title: "Add new plan", style: .plain, target: self, action: #selector(addBigTaskTapped))
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentUser?.ongoingTasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: bigTaskTable.frame.size.width, height: 10))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bigTaskTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskCell
        
        let currBigTask = currentUser!.ongoingTasks[(indexPath as NSIndexPath).section]
        cell.titleLabel.text = currBigTask.title
        cell.progressLabel.text = "Progress: \(currBigTask.countProgress())"
        cell.manageButton.bigTask = currBigTask
        cell.manageButton.addTarget(self, action: #selector(goToManageBigTask(_:)), for: .touchUpInside)
        cell.setState(K.State.isViewing)
        
        return cell
    }
    
    @objc func goToManageBigTask(_ sender: TaskButton){
        let vc = ManageBigTaskVC()
        vc.currBigTask = sender.bigTask
        
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        bigTaskTable.deselectRow(at: indexPath, animated: true)
    }
}

