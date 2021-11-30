//
//  JoinViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/27.
//

import UIKit

class JoinViewController: UIViewController {
    
    static let identifier = "JoinViewController"
    
    var userDefaults: User?
    var userModel = UserModel()
    var passFlag = false
    var phoneNumberCheck = false
    var emailCheck = false
    let activityIndicator = UIActivityIndicatorView()
    
    typealias CompletionHandler = () -> ()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailCheckInfoLabel: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passCheckInfoLabel: UILabel!
    @IBOutlet weak var passCheckField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var phoneNumCheckInfoLabel: UILabel!
    @IBOutlet weak var emailDoubleCheck: UIButton!
    @IBOutlet weak var phoneNumDoubleCheck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNotificationCenter()
        
        self.nameField.addTarget(self, action: #selector(self.nameFieldDidChange(_:)), for: .editingChanged)
        self.emailField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: .editingChanged)
        self.passField.addTarget(self, action: #selector(self.passFieldDidChange(_:)), for: .editingChanged)
        self.passCheckField.addTarget(self, action: #selector(self.passCheckFieldDidChange(_:)), for: .editingChanged)
        self.phoneNumField.addTarget(self, action: #selector(self.phoneNumFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setButtonUI(_ button: UIButton) {
        button.setTitle("중복확인", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "Color")
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.isHidden = true
    }
    
    func setUI() {
        setButtonUI(emailDoubleCheck)
        setButtonUI(phoneNumDoubleCheck)
        
        titleLabel.text = "회원가입"
        titleLabel.textColor = UIColor(named: "Color")
        titleLabel.backgroundColor = .clear
        titleLabel.font = .boldSystemFont(ofSize: 30)
        
        nameField.placeholder = "이름"
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .none
        
        emailField.placeholder = "아이디(이메일)"
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        
        passField.placeholder = "비밀번호(8자리 이상)"
        passField.autocorrectionType = .no
        passField.autocapitalizationType = .none
        passField.isSecureTextEntry = true
        
        passCheckField.placeholder = "비밀번호 확인"
        passCheckField.autocorrectionType = .no
        passCheckField.autocapitalizationType = .none
        passCheckField.isSecureTextEntry = true
        
        joinButton.setTitle("Join", for: .normal)
        joinButton.backgroundColor = UIColor(named: "Color")
        joinButton.tintColor = .white
        joinButton.isHidden = true
        joinButton.layer.cornerRadius = 15
        
        emailCheckInfoLabel.font = .systemFont(ofSize: 12)
        emailCheckInfoLabel.isHidden = true
        
        passCheckInfoLabel.font = .systemFont(ofSize: 10)
        passCheckInfoLabel.isHidden = true
        passCheckInfoLabel.numberOfLines = 3
        passCheckInfoLabel.sizeToFit()
        
        phoneNumField.placeholder = "연락처(ex)00000000000)"
        phoneNumField.keyboardType = .decimalPad
        
        phoneNumCheckInfoLabel.font = .systemFont(ofSize: 12)
        phoneNumCheckInfoLabel.isHidden = true
        phoneNumCheckInfoLabel.sizeToFit()
        
        checkImage.isHidden = true
    }
    
    @IBAction func emailDoubleCheckButtonPressed(_ sender: UIButton) {
        checkEmail()
        
        drawIndicator(activityIndicator: activityIndicator, isActive: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.changeEmailButtonUI()
            self.checkConfirm()
            self.drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
        }
    }
    
    @IBAction func phoneNumDoubleCheckPressed(_ sender: UIButton) {
        checkPhoneNum()
        
        drawIndicator(activityIndicator: activityIndicator, isActive: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.changePhoneButtonUI()
            self.checkConfirm()
            self.drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
        }
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        userDefaults?.phoneNum = phoneNumField.text!
        userDefaults?.pass = passField.text!
        userDefaults?.id = emailField.text!
        
        HungryAPIManager.shared.postIdPwdApiData(email: emailField.text!, pass: passField.text!, name: nameField.text!, phone: phoneNumField.text!) { code, json in
            
            print(json)
            print(code)
            
            switch code {
            case 200:
                print("success")
                let data = json["data"].arrayValue
                
//                for item in data {
//                    let realData = item["id"].intValue
//                    print("real : ", realData)
//                }
                
                let userID = data[0]["id"].intValue
                
                print("id : ", userID)
                
                self.userDefaults?.index = String(userID)
                self.login()
            case 400:
                print("error")
            default:
                print("ERROR")
            }
        }
        
        dismissObserver()
        self.dismiss(animated: true, completion: nil)
    }
    
    func login() {
        UserDefaultManager.shared.user = userDefaults!
        UserDefaultManager.shared.save()
        print("login : ", UserDefaultManager.shared.user)
        
        // 로그인 성공시
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: TabBarViewController.identifier) as! TabBarViewController
        
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func emailFieldDidChange(_ sender: Any?) {
        emailDoubleCheck.setTitle("중복확인", for: .normal)
        emailCheck = false
        
        guard let email = emailField.text?.lowercased(), !email.isEmpty else { return }
        
        if userModel.isValidEmail(id: email) { // 성공시
            if self.view.viewWithTag(100) != nil {
                emailCheckInfoLabel.isHidden = true
                emailDoubleCheck.isHidden = false
                self.checkConfirm()
            }
        } else {
            emailCheckInfoLabel.isHidden = false
            emailCheckInfoLabel.text = "이메일 형식을 확인해 주세요"
            emailCheckInfoLabel.textColor = UIColor.red
            emailCheckInfoLabel.tag = 100
            joinButton.isHidden = true
            emailDoubleCheck.isHidden = true
            return
        }
    }
    
    @objc func nameFieldDidChange(_ sender: Any?) {
        checkConfirm()
    }
    
    @objc func passCheckFieldDidChange(_ sender: Any?) {
        guard let pass = passField.text, !pass.isEmpty else { return }
        guard let passCheck = passCheckField.text, !passCheck.isEmpty else { return }
        
        if userModel.isValidPassword(pwd: passCheck) { // 성공시
            if self.view.viewWithTag(105) != nil {
                checkImage.isHidden = false
                checkImage.image = UIImage(systemName: "checkmark.circle")
                checkImage.tintColor = .green
                passFlag = true
                checkConfirm()
            }
        } else {
            passCheckField.tag = 105
            checkImage.isHidden = false
            checkImage.image = UIImage(systemName: "x.circle")
            checkImage.tintColor = .red
            joinButton.isHidden = true
            passFlag = false
        } // 비밀번호 형식 오류
    }
    
    @objc func passFieldDidChange(_ sender: Any?) {
        guard let password = passField.text, !password.isEmpty else { return }
        
        if userModel.isValidPassword(pwd: password) { // 성공시
            if self.view.viewWithTag(101) != nil {
                self.passCheckInfoLabel.isHidden = true
                self.checkConfirm()
                //removable.removeFromSuperview()
            }
        } else {
            passCheckInfoLabel.isHidden = false
            passCheckInfoLabel.text = "비밀번호 형식을 확인해 주세요(8자 이상, 하나 이상의 대문자, 하나 이상의 소문자, 하나 이상의 특수문자(~!@#$%^&*), 그 외 불포함)"
            passCheckInfoLabel.textColor = UIColor.red
            passCheckInfoLabel.tag = 101
            joinButton.isHidden = true
        } // 비밀번호 형식 오류
    }
    
    @objc func phoneNumFieldDidChange(_ sender: UITextField) {
        phoneNumDoubleCheck.setTitle("중복확인", for: .normal)
        phoneNumberCheck = false
        
        // 서버에서 번호 체크
        let phoneNum = sender.text!
        
        if (Int(phoneNum) == nil) || (phoneNum.count != 11) {
            phoneNumCheckInfoLabel.isHidden = false
            phoneNumCheckInfoLabel.text = "숫자 11자리로 입력해 주세요. ex) 00000000000"
            phoneNumCheckInfoLabel.textColor = .red
            phoneNumCheckInfoLabel.tag = 102
            joinButton.isHidden = true
            phoneNumDoubleCheck.isHidden = true
        } else { // 성공시
            phoneNumCheckInfoLabel.isHidden = true
            phoneNumDoubleCheck.isHidden = false
            checkConfirm()
        }
    }
    
    func changeEmailButtonUI() {
        if self.emailCheck {
            self.emailDoubleCheck.setTitle("완료", for: .normal)
        } else {
            self.emailDoubleCheck.setTitle("중복확인", for: .normal)
            self.showToast(message: "중복된 이메일 입니다.")
        }
    }
    
    func changePhoneButtonUI() {
        if self.phoneNumberCheck {
            self.phoneNumDoubleCheck.setTitle("완료", for: .normal)
        } else {
            self.showToast(message: "중복된 번호 입니다.")
        }
    }
    
    func checkConfirm() {
        let name = nameField.text!
        let email = emailField.text!
        let pass = passField.text!
        let passCheck = passCheckField.text!
        let phoneNum = phoneNumField.text!
        
        if !name.isEmpty && !email.isEmpty && !pass.isEmpty && !passCheck.isEmpty && !phoneNum.isEmpty && passFlag && phoneNumberCheck && emailCheck {
            joinButton.isHidden = false
        } else {
            joinButton.isHidden = true
        }
    }
    
    func checkEmail() {
        HungryAPIManager.shared.getAvailableEmail(email: emailField.text!) { code, json in
            switch(code) {
            case 200:
                let result = json["result"].stringValue
                if result == "FAILURE" {
                    self.emailCheck = false
                    self.emailDoubleCheck.isHidden = false
                } else {
                    self.emailCheck = true
                    self.emailDoubleCheck.isHidden = false
                }
            case 400:
                print("error")
                self.emailCheck = false
            default:
                print("ERROR")
                self.emailCheck = false
            }
        }
    }
    
    func checkPhoneNum() {
        HungryAPIManager.shared.getAvailablePhoneNum(phoneNum: phoneNumField.text!) { code, json in
            switch(code) {
            case 200:
                print("success")
                let result = json["result"].stringValue
                if result == "FAILURE" {
                    self.phoneNumberCheck = false
                    self.phoneNumDoubleCheck.isHidden = false
                } else {
                    self.phoneNumberCheck = true
                    self.phoneNumDoubleCheck.isHidden = false
                }
            case 400:
                print("error")
                self.phoneNumberCheck = false
            default:
                print("ERROR")
                self.phoneNumberCheck = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissObserver() {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.textFieldView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height / 2 - keyboardSize.height))
            })
        }
    }
    
    @objc func textViewMoveDown(_ notification: NSNotification) {
        self.textFieldView.transform = .identity
    }
}
