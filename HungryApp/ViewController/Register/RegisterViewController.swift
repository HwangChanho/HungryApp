//
//  RegisterViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/22.
//

import Photos
import UIKit

class RegisterViewController: UIViewController {
    
    static let identifier = "RegisterViewController"
    
    let pickerList = ["한식", "분식", "카페디저트", "일식", "치킨", "피자", "아시안", "중식", "족발보쌈", "야식", "찜탕", "도시락", "패스트푸드", "베스트"]
    var pickerView = UIPickerView()
    
    let picker = UIImagePickerController()
    let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
    var nowPage = 0
    var aData: [addressDataByKeyworld] = []
    var selectedData: addressDataByKeyworld?
    var filteredAData: [addressDataByKeyworld] = []
    var totalCount = 0
    var count = 0
    var page = 0
    var searchText = ""
    var cellTapped = false
    var starNumber: Int = 5
    var currentStar: Int = 0
    private var buttons: [UIButton] = []
    private var images: [UIImage] = []
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setNib()
        setNotificationCenter()
        setButton()
        setLabel()
        setTableView()
        bind()
        setNavigation()
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
        collectionView.backgroundColor = .lightGray
    }
    
    func bind() {
        for i in 0..<5 {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.tag = i
            button.tintColor = UIColor(named: "Color")
            buttons += [button]
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTapButton(sender: UIButton) {
        let end = sender.tag
        
        for i in 0...end {
            buttons[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        for i in end + 1..<starNumber {
            buttons[i].setImage(UIImage(systemName: "star"), for: .normal)
        }
        currentStar = end + 1
        print("currentStar : ", currentStar)
    }
    
    func setNavigation() {
        let firstBarItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        var rightBarButtons: [UIBarButtonItem] = []
        rightBarButtons.append(firstBarItem)
        self.navigationItem.rightBarButtonItems = rightBarButtons
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color")
    }
    
    func setStarImage() {
        stars.map{ $0.image = UIImage(systemName: "star") }
    }
    
    func setTableView() {
        tableView.layer.cornerRadius = 15
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
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
    
    func setNib() {
        let nibName = UINib(nibName: RegisterCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: RegisterCollectionViewCell.identifier)
        
        let tableViewNibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        self.tableView.register(tableViewNibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func setDelegate() {
        self.picker.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.titleLabel.delegate = self
        self.addressLabel.delegate = self
        self.textField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        self.pickerFrame.delegate = self
        self.pickerFrame.dataSource = self
    }
    
    func setLabel() {
        titleLabel.placeholder = "음식점 검색"
        titleLabel.tintColor = .lightGray
        titleLabel.textColor = .white
        titleLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleLabel.tag = 111
        
        addressLabel.placeholder = "주소 검색"
        addressLabel.tintColor = .lightGray
        addressLabel.textColor = .white
        addressLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addressLabel.tag = 112
        
        textField.text = "리뷰작성"
        textField.textColor = .lightGray
    }
    
    func setButton() {
        submitButton.backgroundColor = UIColor(named: "Color")
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 15
        submitButton.setTitle("등록", for: .normal)
        
        categoryButton.tintColor = .white
        categoryButton.backgroundColor = UIColor(named: "Color")
        categoryButton.setTitle("카테고리 선택", for: .normal)
        categoryButton.layer.cornerRadius = 10
    }
    
    @objc func textViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.middleView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height / 3))
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height / 3))
            })
        }
    }
    
    @objc func textViewMoveDown(_ notification: NSNotification) {
        self.middleView.transform = .identity
        self.bottomView.transform = .identity
    }
    
    func showAlert() {
        let alert =  UIAlertController(title: "이미지 등록", message: nil, preferredStyle: .actionSheet)
        
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
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        print("submitted")
        print("data : ", selectedData, "image : ", images)
        
        selectedData?.review = textField.text
        selectedData?.rating = String(currentStar)
        if titleLabel.text == nil {
            shakeTextField(textField: titleLabel)
            return
        }
        if addressLabel.text == nil {
            shakeTextField(textField: addressLabel)
            return
        }
        
        if titleLabel.text == nil || addressLabel.text == nil || categoryButton.titleLabel?.text == "카테고리 선택" {
            showToast(message: "등록되지 않은 필드가 존재 합니다.")
            return
        }
        
        // 사진 전송 images[]
    }
    
    @IBAction func categorySelect(_ sender: UIButton) {
        showFoodCategoryAlert(pickerFrame: pickerFrame)
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
            self.picker.delegate = self
            self.present(self.picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ state in
                if state == .authorized {
                    self.picker.sourceType = .camera
                    self.picker.delegate = self
                    self.present(self.picker, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        default:
            break
        }
        //        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
        //            picker.sourceType = .camera
        //            present(picker, animated: false, completion: nil)
        //        } else {
        //            print("Camera not available")
        //        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 현재의 뷰(이미지 피커) 제거
        self.dismiss(animated: true, completion: nil)
    }
    
    // 텍스트 필드에 실시간 반응
    @objc func textFieldDidChange(_ textField: UITextField) {
        cellTapped = false
        
        if textField.tag == 111 {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
                tableView.widthAnchor.constraint(equalToConstant: self.titleLabel.bounds.width - 10),
                tableView.heightAnchor.constraint(equalToConstant: 132),
                tableView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
                tableView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor),
                tableView.widthAnchor.constraint(equalToConstant: self.addressLabel.bounds.width),
                tableView.heightAnchor.constraint(equalToConstant: 132),
                tableView.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
                tableView.leftAnchor.constraint(equalTo: addressLabel.rightAnchor),
            ])
        }
        
        searchText = textField.text!
        print("searchText : ", searchText)
        
        tableView.isHidden = false
        aData.removeAll()
        fetchKakaoLocalAPIData(text: searchText, x: nil, y: nil, page: nil)
        if searchText.isEmpty {
            tableView.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // navigation 버튼
    @objc func addButtonPressed(_ sender: UIButton) {
        self.showAlert()
    }
    
    //MARK: - APISetup
    
    func fetchKakaoLocalAPIData(text: String, x: String?, y: String?, page: String?) {
        KakaoLocalAPIManager.shared.getKakaoLocalApiData(url: Constants.requestAPI.requestByAddressAndKeyword, keyword: text, x: x, y: y, page: page) { code, json in
            
            let countItem = json["meta"]["total_count"].intValue
            let page = json["meta"]["pageable_count"].intValue
            self.totalCount = countItem
            self.page = page
            
            if countItem == 0 {
                self.tableView.isHidden = true
            }
            
            for item in json["documents"].arrayValue {
                
                let addressName = item["address_name"].string
                let categoryGroupName = item["category_group_name"].string ?? ""
                let categoryGroupCode = item["category_group_code"].string ?? ""
                let phone = item["phone"].string ?? ""
                let placeName = item["place_name"].string ?? ""
                let placeUrl = item["place_url"].string ?? ""
                let roadAddressName = item["road_address_name"].string
                let longitudeX = item["x"].string
                let latitudeY = item["y"].string
                
                switch categoryGroupCode {
                case "MT1", "CS2", "CT1", "AT4", "FD6", "CE7":
                    let data = addressDataByKeyworld(address_name: addressName!, category_group_name: categoryGroupName, category_group_code: categoryGroupCode, phone: phone, place_name: placeName, place_url: placeUrl, road_address_name: roadAddressName!, x: longitudeX!, y: latitudeY!, category: nil)
                    
                    self.aData.append(data)
                    
                    self.tableView.reloadData()
                    self.cellTapped = true
                default:
                    self.tableView.reloadData()
                    break;
                }
            }
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("info : ", info)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            if images.count > 5 {
                showToast(message: "사진은 5개까지만 등록이 가능합니다.")
            } else {
                images.append(image)
            }
        }
        
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = images[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCollectionViewCell.identifier, for: indexPath) as? RegisterCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = row
        
        return cell
    }
    
    // 컬렉션뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    // 컬렉션뷰 감속 끝났을 때 현재 페이지 체크
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension RegisterViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 텍스트필드 입력 시작시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textField.text.isEmpty {
            textField.text = "리뷰 입력"
        }
    }
}

extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        let row = aData[indexPath.row]
        
        cell.searchedLabel.text = row.place_name
        
        let attributedString = NSMutableAttributedString(string: row.place_name!.lowercased())
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (row.place_name!.lowercased() as NSString).range(of: searchText.lowercased()))
        cell.searchedLabel.attributedText = attributedString
        
        cell.detailLabel.text = row.address_name
        cell.categoryLabel.text = row.category_group_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !cellTapped {
            return
        }
        tableView.isHidden = true
        
        let row = aData[indexPath.row]
        selectedData = aData[indexPath.row]
        
        titleLabel.text = row.place_name
        addressLabel.text = row.address_name
    }
}

extension RegisterViewController: UITableViewDataSourcePrefetching {
    // 셀이 화면에 보이기 전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if aData.count - 1 == indexPath.row {
                count += 1
                fetchKakaoLocalAPIData(text: searchText, x: nil, y: nil, page: String(count))
                print("total Count : ", totalCount, "page : ", page, "count : ", count)
                // 서버에 요청
            } else if count == totalCount {
                print("end")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("취소 : \(indexPaths)")
    }
    
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryButton.setTitle(pickerList[row], for: .normal)
        selectedData?.category = pickerList[row]
        
        print("selectedData : ", selectedData)
    }
}
