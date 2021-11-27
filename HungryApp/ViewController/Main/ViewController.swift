//
//  ViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/20.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {
    
    static let identifier = "MainView"
    
    var locationManager: CLLocationManager!
    var cameraPositon = NMFCameraPosition()
    var resultVC = UITableViewController()
    
    var aData: [addressDataByKeyworld] = []
    var selectedData: addressDataByKeyworld?
    var filteredAData: [addressDataByKeyworld] = []
    var totalCount = 0
    var page = 0
    var searchText = ""
    var markerToggle = false
    
    let infoWindow = NMFInfoWindow()
    let dataSource = NMFInfoWindowDefaultTextSource.data()
    let marker = NMFMarker()
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nowLocationButton: UIButton!
    
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
        
        let nowPosition = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        mapView.moveCamera(nowPosition, completion: nil)
        
        HungryAPIManager.shared.getHungryApiData(option: "stores") { code, json in
            print("in ------------ in")
            print(json)
            print(code)
        }
    }
    
    //MARK: - UISetup
    func setTabBarController() {
        self.tabBarController?.tabBar.items![0].image = UIImage(named: "house")
        self.tabBarController?.tabBar.items![1].image = UIImage(named: "location")
        self.tabBarController?.tabBar.items![2].image = UIImage(named: "plus")
        self.tabBarController?.tabBar.items![3].image = UIImage(named: "human")
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
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
        //self.searchedTableView.prefetchDataSource = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setMapView() {
        self.mapView.addCameraDelegate(delegate: self)
        self.mapView.isNightModeEnabled = true
        self.mapView.mapType = .basic
        self.mapView.positionMode = .direction
        self.mapView.zoomLevel = 17
    }
    
    //서치바 세팅
    func setSearchBar(){
        searchBar.placeholder = "검색"
        //왼쪽 서치아이콘 이미지 세팅하기
        //searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: UISearchBar.Icon.search, state: .normal)
        //오른쪽 x버튼 이미지 세팅하기
        //searchBar.setImage(UIImage(systemName: "x.circle"), for: .clear, state: .normal)
        searchBar.backgroundColor = .clear
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        //searchBar.barTintColor = .tertiarySystemBackground
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
        nowLocationButton.setImage(UIImage(named: "Ellipse1"), for: .normal)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        mapView.moveCamera(cameraUpdate)
    }
    
    //MARK: - APISetup
    
    func fetchKakaoLocalAPIData(text: String, x: String?, y: String?, page: String?) {
        KakaoLocalAPIManager.shared.getKakaoLocalApiData(url: Constants.requestAPI.requestByAddressAndKeyword, keyword: text, x: x, y: y, page: page) { code, json in
            
            let countItem = json["meta"]["total_count"].intValue
            let page = json["meta"]["pageable_count"].intValue
            self.totalCount = countItem
            self.page = page
            
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
                    let data = addressDataByKeyworld(address_name: addressName!, category_group_name: categoryGroupName, category_group_code: categoryGroupCode, phone: phone, place_name: placeName, place_url: placeUrl, road_address_name: roadAddressName!, x: longitudeX!, y: latitudeY!)
                    
                    self.aData.append(data)
                    
                    self.searchedTableView.reloadData()
                default:
                    self.searchedTableView.reloadData()
                    break;
                }
            }
        }
    }
    
    //MARK: - Toolbar Button Actions
    
    //    @IBAction func settingButtonClicked(_ sender: Any) {
    //        let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
    //        let vc = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    //
    //        vc.modalPresentationStyle = .fullScreen
    //
    //        present(vc, animated: true, completion: nil)
    //    }
    
}

//MARK: - MapViewTouchDelegate

extension ViewController: NMFMapViewCameraDelegate {
    
    // 카메라 이동시 액션
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        //        let cameraPosition = mapView.cameraPosition
        //        print(cameraPosition.target.lat, cameraPosition.target.lng)
    }
    
    //    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView!{
    //
    //    }
    
    // 지도를 탭하면 정보 창을 닫음
    //    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    //        print("map tapped")
    //        infoWindow.close()
    //        self.collectionView.isHidden = true
    //        self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
    //        self.view.endEditing(true)
    //        //self.mapView.endEditing(true)
    //    }
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
        print(#function)
        
        //        print("loc in :", locationManager.location?.coordinate ?? "")
        //        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        //        mapView.moveCamera(cameraUpdate)
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
    
    func setMarker(lat: Double, lng: Double, type: Int, infoWindowText: String?) {
        marker.position = NMGLatLng(lat: lat, lng: lng)
        
        switch type {
        case 1:
            marker.iconImage = NMFOverlayImage(name: "Group2")
        case 2:
            marker.iconImage = NMFOverlayImage(name: "Group1")
        case 3:
            marker.iconImage = NMFOverlayImage(name: "Ellipse1")
        case 4:
            marker.iconImage = NMFOverlayImage(name: "locationSelected")
        default:
            print("Wrong type")
        }
        
        if infoWindowText != nil {
            self.dataSource.title = infoWindowText!
            self.infoWindow.dataSource = self.dataSource
        }
        
        marker.mapView = mapView
        marker.width = 50
        marker.height = 50
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            print("마커 터치")
            self.markerToggle = true
            if self.marker.infoWindow == nil {
                // 현재 마커에 정보 창이 열려있지 않을 경우 열기
                self.infoWindow.open(with: self.marker)
                self.collectionView.isHidden = false
                self.collectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
                self.view.endEditing(true)
            } else {
                // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                self.infoWindow.close()
                self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
                self.collectionView.isHidden = true
            }
            return true // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음
        }
        
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
        print("tableview indexPath : ", indexPath)
        print("aData : ", aData)
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
        print("am i end?")
        self.searchedTableView.isHidden = true
        
        if self.collectionView.isHidden == false && markerToggle == false {
            self.infoWindow.close()
            self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
            self.collectionView.isHidden = true
        }
        
        if self.collectionView.isHidden == false && self.markerToggle == true{
            self.markerToggle = false
            
        }
    }
    
    // 테이블뷰 클릭시 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = aData[indexPath.row]
        
        selectedData = aData[indexPath.row]
        
        // 해당위치로 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(row.y)!, lng: Double(row.x)!))
        mapView.moveCamera(cameraUpdate)
        
        // mark
        cameraPositon = mapView.cameraPosition
        setMarker(lat: cameraPositon.target.lat, lng: cameraPositon.target.lng, type: 4, infoWindowText: selectedData?.place_name)
        
        // show detail
        self.infoWindow.open(with: self.marker)
        self.collectionView.isHidden = false
        self.collectionView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        self.view.endEditing(true)
        
        collectionView.reloadData()
        
        aData.removeAll()
        searchedTableView.reloadData()
        searchedTableView.isHidden = true
        searchBar.text = ""
    }
    
    // 검색시 나타나는 테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // 테이블뷰 섹션 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude // 이게 CGFloat 양수 최소값 상수
    }
    
    //    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    //        for indexPath in indexPaths {
    //            if aData.count - 1 == indexPath.row {
    //                page += 1
    //                fetchKakaoLocalAPIData(text: self.searchText, x: nil, y: nil, page: String(page))
    //                print("indexPath: \(indexPath)", page)
    //                // 서버에 요청
    //            } else if page == totalCount {
    //                print("end")
    //            }
    //        }
    //    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        <#code#>
    //    }
}

//MARK: - SearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    // 사용자가 검색 텍스트를 변경했음을 대리인에게 알립니다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTableView.isHidden = false
        aData.removeAll()
        searchAddress(searchText: searchText)
        self.searchText = searchText
        if searchText.isEmpty {
            searchedTableView.isHidden = true
        }
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
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
            if let url = NSURL(string: "tel://0" + number!),
               
            //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
            UIApplication.shared.canOpenURL(url as URL) {
                
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
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

