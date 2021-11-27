//
//  LoginViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/27.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var searchIdPass: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var textFieldStackView: UIStackView!
    
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        setLoginButton()
        setButtons()
        setNotificationCenter()
        
        self.emailField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setTextField() {
        emailField.placeholder = "아이디 (이메일)"
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        
        passwordField.placeholder = "비밀번호"
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
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
    
    func dismissObserver() {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty else { return }
        guard let password = passwordField.text, !password.isEmpty else { return }
        
        //HungryAPIManager.shared.getIdPwdApiData(option: "users", id: emailField.text, pass: passwordField.text, result: nil)
        
        let loginSuccess: Bool = loginCheck(id: email, pwd: password)
        if loginSuccess {
            print("로그인 성공")
            if let removable = self.view.viewWithTag(102) {
                removable.removeFromSuperview()
            }
            
            dismissObserver()
            
            // 로그인 성공시
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ViewController.identifier) as! ViewController
            
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true, completion: nil)
        } else {
            print("로그인 실패")
            shakeTextField(textField: emailField)
            shakeTextField(textField: passwordField)
            let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
            loginFailLabel.text = "아이디 또는 비밀번호가 다릅니다."
            loginFailLabel.textColor = UIColor.red
            loginFailLabel.tag = 102
            
            self.view.addSubview(loginFailLabel)
        }
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        dismissObserver()
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
    
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
    
    func loginCheck(id: String, pwd: String) -> Bool {
        //HungryAPIManager.shared.getIdPwdApiData(option: "users", id: emailField.text, pass: passwordField.text, result: nil)
        
        //        for user in userModel.users {
        //            if user.email == id && user.password == pwd {
        //                return true // 로그인 성공
        //            }
        //        }
        //        return false
        return true
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
            showToast(message: "이메일 형식을 확인해 주세요")
            // emailField.viewWithTag(100)
        }
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0 }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
        })
    }
    
}
