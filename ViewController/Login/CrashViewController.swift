//
//  CrashViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/12/06.
//

import UIKit
import Firebase
import FirebaseCrashlytics

class CrashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// fatal error
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        let keysAndValues = [
                         "string key" : "string value",
                         "string key 2" : "string value 2",
                         "boolean key" : true,
                         "boolean key 2" : false,
                         "float key" : 1.01,
                         "float key 2" : 2.02
                        ] as [String : Any]

        Crashlytics.crashlytics().setCustomKeysAndValues(keysAndValues)
        
        fatalError()
    }
}
