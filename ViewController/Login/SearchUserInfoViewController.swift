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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var emailField = ""
    var segmentflag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.placeholder = "등록한 ID를 입력해주세요"
        idTextField.tintColor = .lightGray
        
        nameTextField.placeholder = "전화번호를 입력해주세요"
        nameTextField.tintColor = .lightGray
        nameTextField.keyboardType = .numberPad
        
        passLabel.text = ""
        passLabel.textColor = .red
        
        searchButton.setTitle("검색", for: .normal)
        searchButton.backgroundColor = UIColor(named: "Color")
        searchButton.layer.cornerRadius = 15
        searchButton.tintColor = .white
        
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = UIColor(named: "Color")
        segmentControl.tintColor = .clear
        segmentControl.setTitle("아이디", forSegmentAt: 1)
        segmentControl.setTitle("비밀번호", forSegmentAt: 0)
        segmentControl.addTarget(self, action: #selector(self.segmentControlDidChange(_:)), for: .valueChanged)
    }
    
    @objc func segmentControlDidChange(_ sender: UISegmentedControl) {
        passLabel.text = ""
        if sender.selectedSegmentIndex == 1 {
            idTextField.isHidden = true
            idTextField.text = nil
            segmentflag = 1
        } else {
            idTextField.isHidden = false
            idTextField.placeholder = "등록한 ID를 입력해주세요"
            idTextField.text = emailField
            segmentflag = 0
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if segmentflag == 0 {
            searchEmail()
        } else {
            searchPass()
        }
    }
    
    func searchEmail() {
        HungryAPIManager.shared.getEmail(email: idTextField.text, phone: nameTextField.text!) { code, json in
            self.Log(json)
            
            switch code {
            case 200:
                print("success")
                let result = json["result"].stringValue
                if result == "FAILURE" {
                    self.showToast(message: "ID를 찾을수 없습니다. 다시 확인해 주세요.")
                } else {
                    let data = json["data"].arrayValue
                    let userPass = data[0].stringValue
                    self.passLabel.text = userPass
                    print("id : ", userPass)
                }
            case 400:
                print("400 error")
                self.showToast(message: "에러: 개발자에게 문의하세요.")
                self.passLabel.isHidden = true
            default:
                print("default ERROR")
                self.showToast(message: "에러: 개발자에게 문의하세요.")
                self.passLabel.isHidden = true
            }
        }
    }
    
    func searchPass() {
        HungryAPIManager.shared.getEmail(email: nil, phone: nameTextField.text!) { code, json in
            print(json)
            print(code)
            
            switch code {
            case 200:
                print("success")
                let result = json["result"].stringValue
                if result == "FAILURE" {
                    self.showToast(message: "비밀번호를 찾을수 없습니다. 다시 확인해 주세요.")
                } else {
                    let data = json["data"].arrayValue
                    let userID = data[0].stringValue
                    self.passLabel.text = userID
                    print("id : ", userID)
                }
            case 400:
                print("400 error")
                self.showToast(message: "에러: 개발자에게 문의하세요.")
                self.passLabel.isHidden = true
            default:
                print("default ERROR")
                self.showToast(message: "에러: 개발자에게 문의하세요.")
                self.passLabel.isHidden = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
