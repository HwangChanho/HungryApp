//
//  ViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/20.
//

import UIKit
import NMapsMap
import Kingfisher

class ViewController: UIViewController {
    
    static let identifier = "MainView"
    
    let activityIndicator = UIActivityIndicatorView()
    var completionHandler: (() -> ())?
    var locationManager: CLLocationManager!
    var cameraPositon = NMFCameraPosition()
    var resultVC = UITableViewController()
    var segueFlag: Bool = false
    
    var aData: [addressDataByKeyworld] = [] // tableview 용
    var selectedData: addressDataByKeyworld?
    var userData: [addressDataByKeyworld] = []
    var totalCount = 0
    var page = 0
    var searchText = ""
    var cellTapped = false
    var markerTouchFlag = false
    
    // let infoWindow = NMFInfoWindow()
    // let dataSource = NMFInfoWindowDefaultTextSource.data()
    var marker = NMFMarker()
    var userMarker = [NMFMarker]()
    // var userDataSource = [NMFInfoWindowDefaultTextSource.data()]
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nowLocationButton: UIButton!
    @IBOutlet weak var homeButtonPressed: UITabBarItem!
    
    override func viewWillAppear(_ animated: Bool) {
        if segueFlag {
            Log("data from Register")
            showSelectedData(x: selectedData!.x, y: selectedData!.y)
        }
        setMarkerfromUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMapView()
        self.setDelegate()
        self.setSearchBar()
        self.setNib()
        self.setTableView()
        self.setCollectionView()
        self.setButtonUI()
        self.setTabBarController()
        
        setNowPosition()
        getUserDefaultsData()
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
    }
    
    //MARK: - UISetup
    
    func setTabBarController() {
        self.tabBarController?.tabBar.items![0].image = UIImage(named: "house")
        self.tabBarController?.tabBar.items![1].image = UIImage(named: "location")
        self.tabBarController?.tabBar.items![2].image = UIImage(named: "plus")
        self.tabBarController?.tabBar.items![3].image = UIImage(named: "human")
        
        // self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color3")
        self.tabBarController?.tabBar.tintColor = UIColor(named: "Color3")
        
        self.tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "houseSelected")
        self.tabBarController?.tabBar.items![1].selectedImage = UIImage(named: "locationSelected")
        self.tabBarController?.tabBar.items![2].selectedImage = UIImage(named: "plusSelected")
        self.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "humanSelected")
    }
    
    func setButtonUI() {
        nowLocationButton.setTitle("", for: .normal)
        nowLocationButton.adjustsImageWhenHighlighted = false
    }
    
    func setNib() {
        let nibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        self.searchedTableView.register(nibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        let collectionViewNibName = UINib(nibName: DetailInfoCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(collectionViewNibName, forCellWithReuseIdentifier: DetailInfoCollectionViewCell.identifier)
    }
    
    func setDelegate() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        self.searchBar.delegate = self
        
        self.searchedTableView.delegate = self
        self.searchedTableView.dataSource = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setMapView() {
        self.mapView.addCameraDelegate(delegate: self)
        self.mapView.isNightModeEnabled = true
        self.mapView.mapType = .basic
        self.mapView.positionMode = .direction
        self.mapView.zoomLevel = 17
        self.mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132) // 한반도 지역으로 제한
        self.mapView.minZoomLevel = 5.0
        self.mapView.maxZoomLevel = 18.0
    }
    
    //서치바 세팅
    func setSearchBar(){
        searchBar.placeholder = "검색"
        searchBar.backgroundColor = .clear
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.searchBarStyle = .minimal
    }
    
    func setTableView() {
        searchedTableView.backgroundColor = .clear
        searchedTableView.separatorStyle = .none
        searchedTableView.isHidden = true
        searchedTableView.flashScrollIndicators()
    }
    
    func setCollectionView() {
        collectionView.isHidden = true
        collectionView.layer.cornerRadius = 25
    }
    
    //MARK: - Action
    
    @IBAction func nowLocationButtonPressed(_ sender: UIButton) {
        nowLocationButton.setImage(UIImage(named: "NowPosition"), for: .normal)
       
        setNowPosition()
        
        drawIndicator(activityIndicator: activityIndicator, isActive: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.collectionView.isHidden = true
            self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        }
        drawIndicator(activityIndicator: activityIndicator, isActive: false)
    }
    
    //MARK: - APISetup
    
    func getUserStoreDataFromDB(category: String?) {
        HungryAPIManager.shared.getAllStoreByUserIndexAndCategory(index: String(UserDefaultManager.shared.user.index), category: category) { code, json in
            switch code {
            case 200:
                let result = json["result"].stringValue
                let data = json["data"].arrayValue
                
                if result == "SUCCESS" {
                    for item in data {
                        // let storeName = item["name"].stringValue
                        let review = item["review"].stringValue
                        let rating = item["rating"].doubleValue
                        let addressName = item["addressName"].stringValue
                        let categoryGroupName = item["categoryGroupName"].stringValue
                        let categoryGroupCode = item["categoryGroupCode"].stringValue
                        let phone = item["phone"].stringValue
                        let placeName = item["placeName"].stringValue
                        let placeUrl = item["placeUrl"].stringValue
                        let roadAddressName = item["roadAddressName"].stringValue
                        let x = item["x"].doubleValue
                        let y = item["y"].doubleValue
                        let category = item["category"].stringValue
                        
                        var photoURL: [String] = []
                        let photo = item["photo"].arrayValue
                        
                        for photoItem in photo {
                            photoURL.append(photoItem["path"].string!)
                        }
                        
                        print("photoURL : ", photoURL)
                        
                        let data = addressDataByKeyworld(address_name: addressName, category_group_name: categoryGroupName, category_group_code: categoryGroupCode, phone: phone, place_name: placeName, place_url: placeUrl, road_address_name: roadAddressName, x: x, y: y, category: category, rating: rating, review: review, photo: photoURL)
                        
                        self.userData.append(data)
                    }
                } else {
                    self.showToast(message: "불러오기 실패")
                }
            case 400:
                print("error")
                self.showToast(message: "개발자에게 문의 바랍니다.")
            default:
                print("ERROR")
                self.showToast(message: "개발자에게 문의 바랍니다.")
            }
        } failResult: { error in
            switch error._code {
            case 13:
                self.showToast(message: "서버에 접속 불가")
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
                self.searchedTableView.isHidden = true
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
                    let data = addressDataByKeyworld(address_name: addressName!, category_group_name: categoryGroupName, category_group_code: categoryGroupCode, phone: phone, place_name: placeName, place_url: placeUrl, road_address_name: roadAddressName!, x: Double(longitudeX!)!, y: Double(latitudeY!)!, category: "", rating: Double(0), review: "", photo: [])
                    
                    self.aData.append(data)
                    
                    self.searchedTableView.reloadData()
                    self.cellTapped = true
                default:
                    self.searchedTableView.reloadData()
                    break;
                }
                
            }
        }
    }
    
    //MARK: - Methods
    
    func setNowPosition() {
        let nowPosition = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        mapView.moveCamera(nowPosition, completion: nil)
    }
    
    func setMarkerfromUserData() {
        getUserStoreDataFromDB(category: nil)
        
        drawIndicator(activityIndicator: activityIndicator, isActive: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            print("count : ", self.userData.count)
            for i in 0 ..< self.userData.count {
                self.userMarker.append(NMFMarker())
                self.userMarker[i].position = NMGLatLng(lat: self.userData[i].y, lng: self.userData[i].x)
                
                self.userMarker[i].mapView = self.mapView
                
                self.userMarker[i].iconImage = NMFOverlayImage(name: "Group2")
                self.userMarker[i].width = 30
                self.userMarker[i].height = 30
                
                self.userMarker[i].touchHandler = { (overlay: NMFOverlay) -> Bool in
                    print("마커 터치")
                    self.markerTouchFlag = true
                    // 컬렉션 뷰에 표시
                    self.selectedData = self.userData[i]
                    print("reload selected : ", self.selectedData)
                    
                    // 해당 위치로 카메라 이동
                    let nowPosition = NMFCameraUpdate(scrollTo: NMGLatLng(lat: self.userData[i].y, lng: self.userData[i].x))
                    self.mapView.moveCamera(nowPosition, completion: nil)
                    
                    if self.collectionView.isHidden {
                        // 현재 마커에 정보 창이 열려있지 않을 경우 열기
                        self.collectionView.isHidden = false
                        self.collectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
                        self.view.endEditing(true)
                    } else {
                        // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                        self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
                        self.collectionView.isHidden = true
                    }
                    
                    self.collectionView.reloadData()
                    return true
                }
            }
        }
        drawIndicator(activityIndicator: activityIndicator, isActive: false)
    }
    
    func setMarker(lat: Double, lng: Double, type: Int, infoWindowText: String?) {
        marker.position = NMGLatLng(lat: lat, lng: lng)
        
        switch type {
        case 1:
            marker.iconImage = NMFOverlayImage(name: "Group2")
            marker.width = 20
            marker.height = 20
        case 2:
            marker.iconImage = NMFOverlayImage(name: "Group1")
            marker.width = 50
            marker.height = 50
        case 3:
            marker.iconImage = NMFOverlayImage(name: "Ellipse1")
            marker.width = 50
            marker.height = 50
        case 4:
            marker.iconImage = NMFOverlayImage(name: "locationSelected")
            marker.width = 50
            marker.height = 50
        default:
            print("Wrong type")
        }
        
        marker.mapView = mapView
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            print("마커 터치")
            self.markerTouchFlag = true
            if self.collectionView.isHidden {
                // 현재 마커에 정보 창이 열려있지 않을 경우 열기
                self.collectionView.isHidden = false
                self.collectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
                self.view.endEditing(true)
            } else {
                // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
                self.collectionView.isHidden = true
            }
            return true // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showSelectedData(x: Double, y: Double) {
        // 해당위치로 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: y, lng: x))
        mapView.moveCamera(cameraUpdate)
        
        // mark
        cameraPositon = mapView.cameraPosition
        setMarker(lat: cameraPositon.target.lat, lng: cameraPositon.target.lng, type: 4, infoWindowText: selectedData?.place_name)
        
        // show detail
        self.collectionView.isHidden = false
        self.collectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        self.view.endEditing(true)
        
        collectionView.reloadData()
        
        aData.removeAll()
        searchedTableView.reloadData()
        searchedTableView.isHidden = true
        searchBar.text = ""
    }
    
    //MARK: - @objc

    @objc func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - MapViewTouchDelegate

extension ViewController: NMFMapViewCameraDelegate {
    
    // 카메라 이동시 액션
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    }
}

//MARK: - LocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    // iOS 버전에 따른 분기 처리와 iOS 위치 서비스 여부 확인
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus // iOS14 이상
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus() // iOS14 미만
        }
        
        //iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            // 권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요")
        }
    }
    
    // 사용자의 권한 상태 확인(UDF. 사용자 정의 함수로 프로토콜 내 메서드가 아님!!!!)
    // 사용자의 위치권한 여부 확인 (단, iOS 위치 서비스가 가능한 지 확인)
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() // 위치 접근 시작
            print("notDetermined")
        case .restricted, .denied:
            print("DENIED")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("Always")
        case .authorizedAlways:
            locationManager.startUpdatingLocation() // 위치 접근 시작
            print("authorizedAlways")
        @unknown default:
            print("Default")
        }
        
        if #available(iOS 14.0, *) {
            // 정확도 체크: 정확도 감소가 되어 있을경우, 배터리 up
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .fullAccuracy:
                print("FULL")
            case .reducedAccuracy:
                print("REDUCE")
            @unknown default:
                print("DEFAULT")
            }
        }
    }
    
    // 사용자가 위치 허용을 한 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let nowPosition = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        mapView.moveCamera(nowPosition, completion: nil)
    }
    
    // 위치 접근이 실패했을 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // IOS14 미만: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 떄 대리자에게 승인 상태를 알려줌.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }
    
    // IOS14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    // 주소 찾기
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name {
                    print(name)
                    self.navigationItem.title = name
                } //전체 주소
            }
        })
    }
}

//MARK: - ResultTableViewDelegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aData.count > 10 {
            return 10
        } else {
            return aData.count
        }
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
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
        self.searchedTableView.isHidden = true
        self.view.endEditing(true)
        
        if self.collectionView.isHidden == false && markerTouchFlag == false {
            self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
            self.collectionView.isHidden = true
        }
        
        markerTouchFlag = false
    }
    
    // 테이블뷰 클릭시 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !cellTapped {
            return
        }
        selectedData = aData[indexPath.row]
        selectedData?.photo?.append("x")
        
        showSelectedData(x: selectedData!.x, y: selectedData!.y)
    }
    
    // 검색시 나타나는 테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // 테이블뷰 섹션 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude // 이게 CGFloat 양수 최소값 상수
    }
}

//MARK: - SearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    // 사용자가 검색 텍스트를 변경했음을 대리인에게 알립니다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cellTapped = false
        searchedTableView.isHidden = false
        aData.removeAll()
        searchedTableView.reloadData()
        if searchText.isEmpty {
            searchedTableView.isHidden = true
        }
        self.searchText = searchText
        print(searchText)
        
        searchAddress(searchText: searchText)
    }
    
    // 사용자가 검색 텍스트 편집을 시작할 때 대리인에게 알립니다.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("begin")
        searchedTableView.isHidden = false
    }
    
    // 대리인에게 취소 버튼을 눌렀음을 알립니다.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        searchedTableView.isHidden = true
    }
    
    // 대리자에게 검색 버튼이 탭되었음을 알립니다.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchbutton")
        // searchedTableView.isHidden = true
    }
    
    func searchAddress(searchText: String) {
        fetchKakaoLocalAPIData(text: searchText, x: nil, y: nil, page: nil)
    }
}

//MARK: - CollectionView Delegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // db에서 사진 갯수 가저와서 표출 or 1
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCollectionViewCell.identifier, for: indexPath) as? DetailInfoCollectionViewCell else { return UICollectionViewCell() }
        
        // 단일 결과일 경우
        cell.placeNameLabel.text = selectedData?.place_name
        cell.categoryNameLabel.text = selectedData?.category_group_name
        cell.addressLabel.text = selectedData?.address_name
        cell.placeURLButton.setTitle(selectedData?.place_url, for: .normal)
        cell.phoneButton.setTitle(selectedData?.phone, for: .normal)
        cell.buttonActionHandler = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
            
            vc.url = self.selectedData?.place_url
            
            self.present(vc, animated: true, completion: nil)
        }
        cell.phoneButtonActionHandler = {
            let number = self.selectedData?.phone
            
            // URLScheme 문자열을 통해 URL 인스턴스를 만들어 줍니다.
            if let url = NSURL(string: "tel:" + number!),
               
            //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
            UIApplication.shared.canOpenURL(url as URL) {
                
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        
        
        print("selected Data : ", selectedData?.photo)
        
        if selectedData?.photo![0] != "x" {
            let urlString = selectedData?.photo?[0] ?? ""
            print("urlString : ", urlString)
            
            if urlString != "" {
                cell.imageLabel.kf.setImage(with: URL(string: urlString))
            } else {
                cell.imageLabel.image = UIImage(named: "MainImage")
            }
        } else {
            cell.imageLabel.image = UIImage(named: "MainImage")
        }
        
        return cell
    }
    
    // 컬렉션뷰 사이즈 설정 UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var screenWidth = UIScreen.main.bounds.width
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let leftPadding = window?.safeAreaInsets.left ?? 0
            let rightPadding = window?.safeAreaInsets.right ?? 0
            screenWidth -= (leftPadding + rightPadding)
        }
        
        return CGSize(width: screenWidth - 10, height: 170)
    }
}


