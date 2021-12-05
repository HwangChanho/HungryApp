//
//  SettingViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/21.
//

import Photos
import UIKit
import Kingfisher

class SettingViewController: UIViewController {

    static let identifier = "SettingViewController"
    
    var titleArr: [String] = ["로그아웃", "라이센스"]
    let picker = UIImagePickerController()
    var imageUrl: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        getUserData()
        
        setDelegate()
        setImageView()
        setTableView()
        setNavigation()
        getUserDefaultsData()
        
        let nibName = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
        
        // 사진, 카메라 권한 (최초 요청)
        PHPhotoLibrary.requestAuthorization { status in }
        AVCaptureDevice.requestAccess(for: .video) { granted in }
    }
    
    func setNavigation() {
        let firstBarItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(humanButtonPressed(_:)))
        
        var rightBarButtons: [UIBarButtonItem] = []
        rightBarButtons.append(firstBarItem)
        
        self.navigationItem.rightBarButtonItems = rightBarButtons
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color")
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        picker.delegate = self
    }
    
    func setTableView() {
        tableView.separatorStyle = .none
    }
    
    func setImageView() {
        print(#function)
        
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = imageView.bounds.width / 4
    }
    
    // navigation 버튼
    @objc func humanButtonPressed(_ sender: UIButton) {
        self.showAlert()
    }
    
    func showAlert() {
        let alert =  UIAlertController(title: "프로필 이미지 등록", message: nil, preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            print("notDetermined")
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case .restricted:
            print("restricted")
        case .denied:
            photoSettingAlert()
            print("denied")
        case .authorized:
            self.present(self.picker, animated: true, completion: nil)
        case .limited:
            print("limited")
        @unknown default:
            print("unknown")
        }
        
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.picker.sourceType = .camera
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                print("notDetermined")
                UIApplication.shared.open(URL(string: "UIApplication.openSettingsURLString")!)
            case .restricted:
                print("restricted")
            case .denied:
                cameraSettingAlert()
                print("denied")
            case .authorized:
                self.present(self.picker, animated: true, completion: nil)
            case .limited:
                print("limited")
            default:
                break
            }
        } else {
            print("카메라 사용이 불가능합니다.")
        }
        
    }
    
    //MARK: - API
    
    func getUserData() {
        HungryAPIManager.shared.getUserByID(id: String(UserDefaultManager.shared.user.index)) { code, json in
            
            let result = json["result"].stringValue
            let data = json["data"].arrayValue
            
            switch(code) {
            case 200:
                if result == "SUCCESS" {
                    let photo = data[0]["photo"]["path"].stringValue
                    self.imageUrl = photo
                    if self.imageUrl != nil {
                        self.imageView.kf.setImage(with: URL(string: self.imageUrl!))
                    }
                } else {
                    
                }
            case 400:
                print("error")
                self.showToast(message: "통신 오류")
            default:
                print("ERROR")
                self.showToast(message: "개발자에게 문의 바랍니다.")
            }
        }
    }
    
    func uploadImage(userId: Int, imagePath: String) {
        HungryAPIManager.shared.putUserImage(userId: userId, imagePath: imagePath) { code, json in
            
            let result = json["result"].stringValue
            
            switch(code) {
            case 200:
                if result == "SUCCESS" {
                    self.showToast(message: "저장완료")
                } else {
                    self.showToast(message: "저장실패")
                }
            case 400:
                print("error")
                self.showToast(message: "통신 오류")
            default:
                print("ERROR")
                self.showToast(message: "개발자에게 문의 바랍니다.")
            }
        }
    }
    
    func postImagetoServer(images: UIImage) {
        HungryAPIManager.shared.postImageData(images: images) { code, string in
            switch(code) {
            case 200:
                self.imageUrl = string
                self.uploadImage(userId: UserDefaultManager.shared.user.index, imagePath: string)
            case 400:
                print("error")
                self.showToast(message: "통신 오류")
            default:
                print("ERROR")
                self.showToast(message: "개발자에게 문의 바랍니다.")
            }
        }
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = titleArr[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.menuLabel.text = row
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 로그아웃
            UserDefaultManager.shared.user.id = ""
            UserDefaultManager.shared.user.pass = ""
            UserDefaultManager.shared.user.index = 0
            UserDefaultManager.shared.user.phoneNum = ""
            UserDefaultManager.shared.user.name = ""
            UserDefaultManager.shared.user.autoLoginCheck = false
            UserDefaultManager.shared.user.saveEmailCheck = false
            UserDefaultManager.shared.save()
            
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
            
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true, completion: nil)
        case 1: // 라이센스
            let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: LicenseViewController.identifier) as! LicenseViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("no menu")
        }
    }
    
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
            postImagetoServer(images: image)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

