//
//  LisenceViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/29.
//

import UIKit

class LicenseViewController: UIViewController {
    
    static let identifier = "LicenseViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    let licenses = License()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: LicenseTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: LicenseTableViewCell.identifier)
    }
    
}

extension LicenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        licenses.licenseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LicenseTableViewCell.identifier, for: indexPath) as? LicenseTableViewCell else { return UITableViewCell() }
        
        let title = licenses.licenseList[indexPath.row]
        let content = licenses.contentList[indexPath.row]
        
        cell.title.text = title
        cell.link.setTitle(content, for: .normal)
    
        cell.buttonActionHandler = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
            
            vc.url = content
            
            self.present(vc, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Licenses"
    }
    
}
