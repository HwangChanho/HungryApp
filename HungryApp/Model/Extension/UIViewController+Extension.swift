//
//  UIViewController+Extension.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/29.
//

import UIKit

extension UIViewController {
    typealias CompletionHandler = () -> ()
    
    func cameraSettingAlert() {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alert = UIAlertController(title: "설정", message: "\(appName)이 (가) 카메라 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default) { (action) in
                
            }
            let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 100, y: self.view.frame.size.height / 2 - 100, width: 200, height: 35))
        
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
    
    func showFoodCategoryAlert(pickerFrame: UIPickerView) {
        let alert = UIAlertController(title: "카테고리", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        alert.view.addSubview(pickerFrame)
        
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func setTimer(seconds: Int, result: CompletionHandler?) {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now() + .seconds(seconds))
        timer.setEventHandler {
            print("Timer On")
        }
        timer.activate()
    }
    
    func drawIndicator(activityIndicator: UIActivityIndicatorView, isActive: Bool) {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(named: "Color")
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        
        self.view.addSubview(activityIndicator)
        
        if isActive {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
