//
//  SettingViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/21.
//

import Photos
import UIKit

class SettingViewController: UIViewController {

    static let identifier = "SettingViewController"
    
    var titleArr: [String] = ["로그아웃", "라이센스"]
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setImageView()
        setTableView()
        setNavigation()

        let nibName = UINib(nibName: SettingTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
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
        imageView.backgroundColor = .gray
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
        picker.delegate = self
        
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            cameraSettingAlert()
        case .restricted:
            print("Camera not available")
            break
        case .authorized:
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ state in
                if state == .authorized {
                    self.picker.sourceType = .camera
                    self.present(self.picker, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        default:
            break
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
        case 0: // 설정
            UserDefaultManager.shared.user.id = ""
            UserDefaultManager.shared.user.pass = ""
            UserDefaultManager.shared.save()
            
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
            
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true, completion: nil)
        case 1: // 라이센스
            let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: LisenceViewController.identifier) as! LisenceViewController
            
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
        }
        
        dismiss(animated: true, completion: nil)
    }
}

