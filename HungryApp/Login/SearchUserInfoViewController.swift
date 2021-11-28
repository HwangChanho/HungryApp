//
//  SearchUserInfoViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/29.
//

import UIKit

class SearchUserInfoViewController: UIViewController {
    
    static let identifier = "SearchUserInfoViewController"

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    var emailField = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.placeholder = "등록한 ID를 입력해주세요"
        idTextField.tintColor = .lightGray
        idTextField.text = emailField
        
        nameTextField.placeholder = "등록한 이름을 입력해주세요"
        nameTextField.tintColor = .lightGray
        
        passLabel.text = ""
        passLabel.textColor = .red
        
        searchButton.setTitle("검색", for: .normal)
        searchButton.backgroundColor = UIColor(named: "Color")
        searchButton.layer.cornerRadius = 15
        searchButton.tintColor = .white
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
    }
}
