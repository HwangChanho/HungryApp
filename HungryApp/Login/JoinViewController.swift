//
//  JoinViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/27.
//

import UIKit

class JoinViewController: UIViewController {
    
    static let identifier = "JoinViewController"
    
    var userModel = UserModel()
    var passFlag = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailCheckInfoLabel: UILabel!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passCheckInfoLabel: UILabel!
    @IBOutlet weak var passCheckField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNotificationCenter()
        
        self.nameField.addTarget(self, action: #selector(self.nameFieldDidChange(_:)), for: .editingChanged)
        self.emailField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: .editingChanged)
        self.passField.addTarget(self, action: #selector(self.passFieldDidChange(_:)), for: .editingChanged)
        self.passCheckField.addTarget(self, action: #selector(self.passCheckFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setUI() {
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
        
        emailCheckInfoLabel.font = .systemFont(ofSize: 12)
        emailCheckInfoLabel.isHidden = true
        
        passCheckInfoLabel.font = .systemFont(ofSize: 10)
        passCheckInfoLabel.isHidden = true
        passCheckInfoLabel.numberOfLines = 3
        passCheckInfoLabel.sizeToFit()
        
        checkImage.isHidden = true
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        dismissObserver()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func emailFieldDidChange(_ sender: Any?) {
        guard let email = emailField.text, !email.isEmpty else { return }
        
        if userModel.isValidEmail(id: email) { // 성공시
            if let removable = self.view.viewWithTag(100) {
                emailCheckInfoLabel.isHidden = true
                self.checkConfirm()
                //removable.removeFromSuperview()
            }
        } else {
            emailCheckInfoLabel.isHidden = false
            emailCheckInfoLabel.text = "이메일 형식을 확인해 주세요"
            emailCheckInfoLabel.textColor = UIColor.red
            emailCheckInfoLabel.tag = 100
            joinButton.isHidden = true
        }
    }
    
    @objc func nameFieldDidChange(_ sender: Any?) {
        checkConfirm()
    }
    
    @objc func passCheckFieldDidChange(_ sender: Any?) {
        guard let pass = passField.text, !pass.isEmpty else { return }
        guard let passCheck = passCheckField.text, !passCheck.isEmpty else { return }
        
        if pass == passCheck {
            checkImage.isHidden = false
            checkImage.image = UIImage(systemName: "checkmark.circle")
            checkImage.tintColor = .green
            passFlag = true
            checkConfirm()
        } else {
            checkImage.isHidden = false
            checkImage.image = UIImage(systemName: "x.circle")
            checkImage.tintColor = .red
            joinButton.isHidden = true
            passFlag = false
        }
    }
    
    func checkConfirm() {
        let name = nameField.text!
        let email = emailField.text!
        let pass = passField.text!
        let passCheck = passCheckField.text!
        
        if !name.isEmpty && !email.isEmpty && !pass.isEmpty && !passCheck.isEmpty && passFlag {
            joinButton.isHidden = false
        } else {
            joinButton.isHidden = true
        }
    }
    
    @objc func passFieldDidChange(_ sender: Any?) {
        guard let password = passField.text, !password.isEmpty else { return }
        
        if userModel.isValidPassword(pwd: password) { // 성공시
            if let removable = self.view.viewWithTag(101) {
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
