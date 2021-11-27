//
//  SettingViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/21.
//

import UIKit

class SettingViewController: UIViewController {

    static let identifier = "SettingViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()

        let nibName = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.menuLabel.text = "test"
        
        return cell
    }
    
}

