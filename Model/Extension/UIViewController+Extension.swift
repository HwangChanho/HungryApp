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
    
    func photoSettingAlert() {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alert = UIAlertController(title: "설정", message: "\(appName)이 (가) 사진 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?", preferredStyle: .alert)
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
    
    func showToast(message : String, font: UIFont = UIFont.boldSystemFont(ofSize: 18)) {
        let width: CGFloat = 280
        let height: CGFloat = 70
        
        let xCenter: CGFloat = (self.view.frame.size.width / 2) - (width / 2)
        let yCenter: CGFloat = (self.view.frame.size.height / 2) - (height / 2)
        
        let toastLabel = UILabel(frame: CGRect(x: xCenter, y: yCenter - 20, width: width, height: 100))
        
        toastLabel.backgroundColor = UIColor(named: "Color")
        toastLabel.alpha = 0.6
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 12;
        toastLabel.clipsToBounds = true
        toastLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
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
        self.view.bringSubviewToFront(activityIndicator)
        
        if isActive {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func getUserDefaultsData() {
        UserDefaultManager.shared.load()
    }
    
    func saveUserDefaultsData() {
        UserDefaultManager.shared.save()
    }
    
    func moveToMainView() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: TabBarViewController.identifier) as! TabBarViewController
        
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
     func longPressCalled(_ longPress: inout UILongPressGestureRecognizer, tableView: inout UITableView, tableViewArr: inout [Any]) {
     // longPressCalled(_ longPress: UILongPressGestureRecognizer, tableView: &tableView, tableViewArr: Arr[])
     Log("longPressCalled")
     
     // 1. 누른 위치의 indexPath
     let locationInView = longPress.location(in: tableView)
     let indexPath = tableView.indexPathForRow(at: locationInView)
     
     // 2. 스냅샷과 최초 indexPath 변수
     // 매서드 밖에서 선언 가능, 매서드 안에서 선언할 경우 static으로 선언하여 stack 메모리가 아닌 static 메모리에 저장해야 함 (struct, class 모두 가능)
     // 이는 longPressCalled 매서드는 동작 하나하나마다 새로 호출되므로 stack에 두게 되면 메서드가 완료될 떄마다 사라지게 되기 떄문임
     struct My {
     static var cellSnapShot: UIView?
     }
     
     struct Path {
     static var initialIndexPath: IndexPath?
     }
     
     // 3. longPress 제스처의 state에 따라 수행할 코드 정의
     switch longPress.state {
     
     case UIGestureRecognizer.State.began:
     print("began")
     
     // 최초 indexPath 설정 및 스냅샷 찍기
     guard let indexPath = indexPath else { return }
     guard let cell = tableView.cellForRow(at: indexPath) else { return }
     Path.initialIndexPath = indexPath
     My.cellSnapShot = snapshotOfCell(cell)
     
     // 스냅샷의 센터지점 설정하고 테이블에 추가
     var center = cell.center
     My.cellSnapShot!.center = center
     My.cellSnapShot!.alpha = 0.0
     tableView.addSubview(My.cellSnapShot!)
     
     // 스냅샷 나타남 및 원래 셀 사라짐 애니메이션 효과주기
     UIView.animate(withDuration: 0.25) { () -> Void in
     center.y = locationInView.y
     My.cellSnapShot!.center = center
     My.cellSnapShot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.0)
     My.cellSnapShot!.alpha = 0.98
     cell.alpha = 0.0
     } completion: { (finished) -> Void in
     if finished {
     cell.isHidden = true
     }
     }
     
     case UIGestureRecognizer.State.changed:
     Log("Changed")
     
     // 위아래로 스냅샷을 끌고 갈 떄마다 스냅샷의 y축 위치 변화시켜 같이 움직이도록 함
     var center = My.cellSnapShot!.center
     center.y = locationInView.y
     My.cellSnapShot!.center = center
     
     // 최초 indexPath가 아닌 다른 indexPath로 이동한 경우 데이터와 테이블뷰 모두 업데이트함
     if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
     swap(&tableViewArr[indexPath!.row], &tableViewArr[Path.initialIndexPath!.row])
     tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
     Path.initialIndexPath = indexPath
     }
     
     default:
     Log("finished")
     
     // 손가락을 때면 이동한 indexPath에 셀이 나타나는 애니메이션 준비
     guard let cell = tableView.cellForRow(at: Path.initialIndexPath!) else { return }
     cell.isHidden = false
     cell.alpha = 0.0
     
     // 스냅샷 사라짐 및 셀 나타나는 애니메이션 주기
     UIView.animate(withDuration: 0.25, animations: { () -> Void in
     My.cellSnapShot!.center = cell.center
     My.cellSnapShot!.transform = CGAffineTransform.identity
     My.cellSnapShot!.alpha = 0.0
     cell.alpha = 1.0
     }, completion: { (finished) -> Void in
     if finished {
     Path.initialIndexPath = nil
     My.cellSnapShot!.removeFromSuperview()
     My.cellSnapShot = nil
     }
     })
     }
     }
     */
    
    public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
#if DEBUG
        if let obj = object {
            print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) \(funcName) : \(obj)")
        } else {
            print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) \(funcName) : nil")
        }
#endif
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
