//
//  RegisterViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/22.
//

import Photos
import UIKit
import Kingfisher
import AVFoundation

class RegisterViewController: UIViewController {
    
    static let identifier = "RegisterViewController"
    
    var pickerView = UIPickerView()
    let foodcate = FoodCategory()
    
    let activityIndicator = UIActivityIndicatorView()
    var completionHandler: (() -> ())?
    let picker = UIImagePickerController()
    let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
    var nowPage = 0
    var aData: [addressDataByKeyworld] = []
    var selectedData = addressDataByKeyworld()
    var totalCount = 0
    var count = 0
    var page = 0
    var storeID: Int?
    var storeIDAvailFlag = false
    var selectedFromRestarantFlag = false
    var searchText = ""
    var cellTapped = false
    var starNumber: Int = 5
    var currentStar: Int = 0
    private var buttons: [UIButton] = []
    private var images: [UIImage] = []
    var urls: [String] = []
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UITextField!
    // @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView.reloadData()
    }
    
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
        
        getUserDefaultsData()
        if selectedFromRestarantFlag {
            print("selected Data in Register : ", selectedData)
        }
        
        // 사진, 카메라 권한 (최초 요청)
        PHPhotoLibrary.requestAuthorization { status in }
        AVCaptureDevice.requestAccess(for: .video) { granted in }
    }
    
    //MARK: - SetUI
    
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
    
    func setNavigation() {
        let firstBarItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        let secondBarItem = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonPressed(_:)))
        
        var rightBarButtons: [UIBarButtonItem] = []
        rightBarButtons.append(firstBarItem)
        rightBarButtons.append(secondBarItem)
        self.navigationItem.rightBarButtonItems = rightBarButtons
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color")
    }
    
    func setStarImage() {
        stars.map{ $0.image = UIImage(systemName: "star") }
        
        print("stars : ", selectedData.rating)
        
        for i in 0 ..< Int(selectedData.rating) {
            stars[i].image = UIImage(systemName: "star.fill")
        }
    }
    
    func setTableView() {
        tableView.layer.cornerRadius = 15
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
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
        // self.addressLabel.delegate = self
        self.textField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.prefetchDataSource = self
        
        self.pickerFrame.delegate = self
        self.pickerFrame.dataSource = self
        
        self.textField.delegate = self
    }
    
    func setLabel() {
        titleLabel.placeholder = "음식점 검색"
        titleLabel.tintColor = .black
        titleLabel.textColor = .gray
        titleLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleLabel.tag = 111
        titleLabel.text = selectedData.place_name ?? ""
        
        // addressLabel.placeholder = "주소"
        addressLabel.tintColor = .black
        addressLabel.textColor = .gray
        //addressLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //addressLabel.tag = 112
        addressLabel.text = selectedData.address_name ?? ""
        
        textField.text = "리뷰작성"
        textField.textColor = .gray
        textField.text = selectedData.review ?? "리뷰작성"
    }
    
    func setButton() {
        submitButton.backgroundColor = UIColor(named: "Color")
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 15
        submitButton.setTitle("등록", for: .normal)
        
        categoryButton.tintColor = .white
        categoryButton.backgroundColor = UIColor(named: "Color")
        categoryButton.setTitle(selectedData.category ?? "카테고리 선택", for: .normal)
        categoryButton.layer.cornerRadius = 10
        categoryButton.titleLabel?.font = .systemFont(ofSize: 15)
        categoryButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    //MARK: - Alert
    
    func showAlert() { // 이미지 한번에 선택하게끔 구현 필요
        let alert =  UIAlertController(title: "이미지 등록 (최대 5장)", message: nil, preferredStyle: .alert)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let delete =  UIAlertAction(title: "사진삭제", style: .destructive) { (action) in
            self.images = []
            self.collectionView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IBAction
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        print("selectedData :", selectedData)
        
        selectedData.review = textField.text
        selectedData.rating = Double(currentStar)
        
        if titleLabel.text == nil {
            shakeTextField(textField: titleLabel)
            return
        }
        
//        if addressLabel.text == nil {
//            shakeTextField(textField: addressLabel)
//            return
//        }
        
        if titleLabel.text == nil || addressLabel.text == nil || categoryButton.titleLabel?.text == "카테고리 선택" {
            showToast(message: "등록되지 않은 필드가 존재 합니다.")
            return
        }
        
        checkStore(storeID: storeID)
        
        if self.storeIDAvailFlag { // 등록된 이력이 없을 경우
            // 사진 전송 images[]
            print("images count : ", self.images.count)
            
            for i in 0 ..< self.images.count {
                HungryAPIManager.shared.postImageData(images: self.images[i]) { code, string in
                    switch(code) {
                    case 200:
                        self.urls.append(string)
                    case 400:
                        print("error")
                        self.showToast(message: "통신 오류")
                    default:
                        print("ERROR")
                        self.showToast(message: "개발자에게 문의 바랍니다.")
                    }
                }
            }
            
            drawIndicator(activityIndicator: activityIndicator, isActive: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                print("photo urls in register : ", self.urls)
                self.selectedData.photo = self.urls
                
                self.fetchData(photoURL: self.urls)
            }
            drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
        } else {
            // 등록된 이력이 있을경우 update
            selectedData.photo = urls
            self.selectedData.review = self.textField.text!
            self.selectedData.category = self.categoryButton.titleLabel?.text
            self.selectedData.rating = Double(self.currentStar)
            
            drawIndicator(activityIndicator: activityIndicator, isActive: true)
            self.updateStoreData(storeID: self.storeID!)
            drawIndicator(activityIndicator: activityIndicator, isActive: false)
        }
        
        showToast(message: "등록 완료")
        
        // 지도로 이동
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewController.identifier) as! ViewController
        
        vc.segueFlag = true
        vc.selectedData = selectedData
        vc.modalPresentationStyle = .fullScreen
        
        if !selectedFromRestarantFlag {
            // 이동전 등록된 데이터 삭제
            self.titleLabel.text = ""
            self.addressLabel.text = ""
            self.images = []
            self.textField.text = ""
            self.categoryButton.setTitle("카테고리 선택", for: .normal)
        }
        
        selectedFromRestarantFlag = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func categorySelect(_ sender: UIButton) {
        showFoodCategoryAlert(pickerFrame: pickerFrame)
    }
    
    //MARK: - Methods
    
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 현재의 뷰(이미지 피커) 제거
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Observer
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func dismissObserver() {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - @objc Methods
    
    @objc func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // navigation 버튼
    @objc func addButtonPressed(_ sender: UIButton) {
        self.showAlert()
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
        }
//        else {
//            NSLayoutConstraint.activate([
//                tableView.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor),
//                tableView.widthAnchor.constraint(equalToConstant: self.addressLabel.bounds.width),
//                tableView.heightAnchor.constraint(equalToConstant: 132),
//                tableView.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
//                tableView.leftAnchor.constraint(equalTo: addressLabel.rightAnchor),
//            ])
//        }
        
        searchText = textField.text!
        print("searchText : ", searchText)
        
        tableView.isHidden = false
        aData.removeAll()
        tableView.reloadData()
        fetchKakaoLocalAPIData(text: searchText, x: nil, y: nil, page: nil)
        if searchText.isEmpty {
            tableView.isHidden = true
        }
        submitButton.isHidden = false
    }
    
    @objc func textViewMoveUp(_ notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
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
    
    // 지도 표시
    @objc func mapButtonPressed(_ sender: UIButton) {
        if selectedData.x != 0 || selectedData.y != 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyBoard.instantiateViewController(withIdentifier: ViewController.identifier) as! ViewController
            
            vc.segueFlag = true
            vc.selectedData = selectedData
            //vc.modalPresentationStyle = .fullScreen
            
            navigationController?.pushViewController(vc, animated: true)
        } else {
            moveToMainView()
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
    
    //MARK: - APISetup
    func checkStore(storeID: Int?) {
        if storeID == nil {
            self.storeIDAvailFlag = true
            return
        }
        
        HungryAPIManager.shared.getStoreById(storeIndex: storeID!) { code, json in
            let result = json["result"].stringValue
            let message = json["message"].stringValue
            print("check getStoreByID : ", json)
            
            if result == "FAILURE" { // 등록가능
                self.storeIDAvailFlag = true
                self.Log("fail")
                self.showToast(message: "등록실패")
            } else { // 존재하는가게
                self.storeIDAvailFlag = false
                switch(code) {
                case 200:
                    self.showToast(message: message)
                case 400:
                    print("error")
                    self.showToast(message: "등록실패")
                default:
                    print("ERROR")
                    self.showToast(message: "개발자에게 문의 바랍니다.")
                }
            }
        } failResult: { error in
            self.storeIDAvailFlag = false
            switch error._code {
            case 13:
                self.showToast(message: "통신 오류")
            default:
                self.showToast(message: "개발자에게 문의 바랍니다.")
            }
        }
    }
    
    // store 등록
    func fetchData(photoURL: [String]) {
        print("store before fetch : ", selectedData)
        HungryAPIManager.shared.postStoreData(storeData: selectedData, index: UserDefaultManager.shared.user.index, photoURL: photoURL) { code, json in
            switch(code) {
            case 200:
                let result = json["result"].stringValue
                
                if result == "FAILURE" {
                    print("fail")
                    self.showToast(message: "등록실패")
                    break
                } else {
                    let data = json["data"].arrayValue
                    for item in data {
                        let storeId = item["id"].intValue
                        
                        self.storeID = storeId
                        print("fetchData store ID : ", storeId)
                        self.updateStoreData(storeID: storeId)
                    }
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
    
    func updateStoreData(storeID: Int) {
        print("store before update : ", selectedData)
        HungryAPIManager.shared.putStoreDataByIndex(storeData: selectedData, storeIndex: storeID, userIndex: UserDefaultManager.shared.user.index) { code, json in
            let result = json["result"].stringValue
            
            if result == "FAILURE" {
                self.Log("fail")
                self.showToast(message: "등록실패")
            } else {
                switch(code) {
                case 200:
                    print("putStore")
                case 400:
                    print("error")
                    self.showToast(message: "등록실패")
                default:
                    print("ERROR")
                    self.showToast(message: "개발자에게 문의 바랍니다.")
                }
            }
        } failResult: { error in
            switch error._code {
            case 13:
                self.showToast(message: "통신 오류")
            default:
                self.showToast(message: "개발자에게 문의 바랍니다.")
            }
        }
    }
    
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
                    let data = addressDataByKeyworld(address_name: addressName!, category_group_name: categoryGroupName, category_group_code: categoryGroupCode, phone: phone, place_name: placeName, place_url: placeUrl, road_address_name: roadAddressName!, x: Double(longitudeX!)!, y: Double(latitudeY!)!, category: nil, rating: Double(0), review: nil, photo: nil)
                    
                    self.aData.append(data)
                    self.drawIndicator(activityIndicator: self.activityIndicator, isActive: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.tableView.reloadData()
                    }
                    self.drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
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

//MARK: - UIImagePicker

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            if images.count > 5 {
                showToast(message: "사진은 5개까지만 등록이 가능합니다.")
            } else {
                images.append(image)
            }
        }
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegate

extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedFromRestarantFlag && selectedData.photo != nil {
            return selectedData.photo!.count
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCollectionViewCell.identifier, for: indexPath) as? RegisterCollectionViewCell else { return UICollectionViewCell() }
        
        if selectedFromRestarantFlag && selectedData.photo != nil {
            let row = selectedData.photo![indexPath.row]
            cell.imageView.kf.setImage(with: URL(string: row))
        } else {
            let row = images[indexPath.row]
            cell.imageView.image = row
        }
        
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

//MARK: - UITextFieldDelegate, UITextViewDelegate

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
            textField.text = "리뷰작성"
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textField.text == "리뷰작성" {
            textField.text = ""
        }
    }
}

//MARK: - UITableViewDelegate

extension RegisterViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
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

//MARK: - UIPickerViewDelegate

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodcate.pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return foodcate.pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryButton.setTitle(foodcate.pickerList[row], for: .normal)
        selectedData.category = foodcate.pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
