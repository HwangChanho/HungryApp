//
//  TabBarViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/28.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    static let identifier = "TabBarViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
}
