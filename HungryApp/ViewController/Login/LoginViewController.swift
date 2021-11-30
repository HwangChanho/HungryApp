//
//  LoginViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/27.
//

import UIKit

class LoginViewController: UIViewController {
    
    static let identifier = "LoginViewController"
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var searchIdPass: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var saveEmailButton: UIButton!
    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var saveEmailLabel: UILabel!
    @IBOutlet weak var autoLoginLabel: UILabel!
    
    var userModel = UserModel()
    var userDefaults: User?
    var loginAvail = false
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImage.image = UIImage(named: "Group2")
        
        setTextField()
        setLoginButton()
        setButtons()
        setNotificationCenter()
        setLoginLabelsAndButtons()
        
        self.emailField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: .editingChanged)
        
        // 유저 defaults에서 검사
        UserDefaultManager.shared.load()
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        if UserDefaultManager.shared.user.id != "" {
            if (UserDefaultManager.shared.user.pass) != "" {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: TabBarViewController.identifier) as! TabBarViewController
                
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true, completion: nil)
            } else {
                emailField.text = UserDefaultManager.shared.user.id
                saveEmailButton.isSelected = true
            }
        }
    }
    
    func setTextField() {
        emailField.placeholder = "아이디 (이메일)"
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        
        passwordField.placeholder = "비밀번호"
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
    }
    
    func setLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.tintColor = .white
        loginButton.backgroundColor = UIColor(named: "Color")
    }
    
    func setButtons() {
        searchIdPass.setTitle("ID/PW 찾기", for: .normal)
        searchIdPass.tintColor = UIColor(named: "Color")
        
        registerButton.setTitle("회원가입", for: .normal)
        registerButton.tintColor = UIColor(named: "Color")
    }
    
    func setLoginLabelsAndButtons() {
        saveEmailLabel.text = "이메일 저장"
        saveEmailLabel.font = .systemFont(ofSize: 12)
        saveEmailLabel.textColor = .gray
        
        saveEmailButton.tintColor = .gray
        saveEmailButton.setTitle("", for: .normal)
        
        autoLoginLabel.text = "자동 로그인"
        autoLoginLabel.font = .systemFont(ofSize: 12)
        autoLoginLabel.textColor = .gray
        
        autoLoginButton.tintColor = .gray
        autoLoginButton.setTitle("", for: .normal)
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
    
    @IBAction func saveEmailButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func autoLoginButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty else { return }
        guard let password = passwordField.text, !password.isEmpty else { return }
        
        loginCheck(id: email, pwd: password)
        
        drawIndicator(activityIndicator: activityIndicator, isActive: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            
            print("avail : ", self.loginAvail)
            
            if self.loginAvail {
                print("로그인 성공")
                if let removable = self.view.viewWithTag(102) {
                    removable.removeFromSuperview()
                }
                
                self.dismissObserver()
                
                UserDefaultManager.shared.user.id = email
                UserDefaultManager.shared.user.pass = password
                UserDefaultManager.shared.save()
                self.drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
                
                // 로그인 성공시
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: TabBarViewController.identifier) as! TabBarViewController
                
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true, completion: nil)
            } else {
                print("로그인 실패")
                self.shakeTextField(textField: self.emailField)
                self.shakeTextField(textField: self.passwordField)
                self.showToast(message: "아이디 또는 비밀번호가 일치하지 않습니다.")
            }
            self.drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        dismissObserver()
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: SearchUserInfoViewController.identifier) as! SearchUserInfoViewController
        
        vc.emailField = emailField.text ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        print("register")
        
        dismissObserver()
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: JoinViewController.identifier) as! JoinViewController
        
        vc.emailField = emailField
        vc.passField = passwordField
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getUserInfo(id: Int) {
        print(#function)
        HungryAPIManager.shared.getUserByID(id: String(id)) { code, json in
            switch code {
            case 200:
                print("success")
                let result = json["result"].stringValue
                
                let data = json["data"].arrayValue
                let userID = data[0]["id"].intValue
                let userEmail = data[0]["email"].stringValue
                let userPhoneNum = data[0]["phone"].stringValue
                
                if result == "SUCCESS" {
                    print("result success")
                    self.userDefaults?.id = userEmail
                    self.userDefaults?.index = String(userID)
                    self.userDefaults?.phoneNum = userPhoneNum
                } else {
                    self.loginAvail = false
                    print("fail")
                }
            case 400:
                self.loginAvail = false
                print("error")
            default:
                self.loginAvail = false
                print("ERROR")
            }
        }
    }
    
    func loginCheck(id: String, pwd: String) {
        print(#function)
        HungryAPIManager.shared.postLoginData(email: id, pass: pwd) { code, json in
            
            print(json)
            print(code)
            
            let result = json["result"].stringValue
            print(result)
            
            switch code {
            case 200:
                print("success")
                let result = json["result"].stringValue
                print("result : ", result)
                
                if result == "SUCCESS" {
                    let data = json["data"].arrayValue
                    let userID = data[0]["id"].intValue
                    print("id : ", userID)
                    self.loginAvail = true
                    self.getUserInfo(id: userID)
                } else {
                    self.loginAvail = false
                }
            case 400:
                self.loginAvail = false
                print("error")
            default:
                self.loginAvail = false
                print("ERROR")
            }
        }
    }
    
    @objc func textViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.textFieldStackView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height / 2 - keyboardSize.height))
            })
        }
    }
    
    @objc func textViewMoveDown(_ notification: NSNotification) {
        self.textFieldStackView.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func emailFieldDidChange(_ sender: Any?) {
        guard let email = emailField.text, !email.isEmpty else { return }
        
        if userModel.isValidEmail(id: email) { // 성공시
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        } else {
            // emailField.viewWithTag(100)
        }
    }
    
}
