//
//  ViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/20.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var cameraPositon = NMFCameraPosition()
    var resultVC = UITableViewController()
    
    var aData: [addressDataByKeyworld] = []
    var filteredAData: [addressDataByKeyworld] = []
    var totalCount = 0
    var page = 0
    var searchText = ""
    
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpMapView()
        self.setDelegate()
        self.setSearchBar()
        self.setNib()
        self.setTableView()
    }
    
    //MARK: - UISetup
    
    func setNib() {
        let nibName = UINib(nibName: SearchTableViewCell.identifier, bundle: nil)
        self.searchedTableView.register(nibName, forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    func setDelegate() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.searchBar.delegate = self
        self.searchedTableView.delegate = self
        self.searchedTableView.dataSource = self
        self.searchedTableView.prefetchDataSource = self
    }
    
    func setUpMapView() {
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
        searchedTableView.layer.cornerRadius = 15
    }
    
    //MARK: - APISetup
    
    func fetchKakaoLocalAPIAddressData(text: String) {
        print(#function)
        aData.removeAll()
        KakaoLocalAPIManager.shared.getKakaoLocalApiData(url: Constants.requestAPI.requestByAddress, keyword: text) { code, json in
            
            let countItem = json["meta"]["total_count"].intValue
            self.totalCount = countItem
            
            if countItem < 10 { // 열개 안 으로 조회될때 표출
                for item in json["documents"].arrayValue {
                    
                    let addressName = item["address_name"].string ?? ""
                    let roadAdressName = item["road_address"].string ?? ""
                    let longitudeX = item["x"].string ?? ""
                    let latitudeY = item["y"].string ?? ""
                    
                    let data = addressData(address_name: addressName, x: longitudeX, y: latitudeY, road_name: roadAdressName)
                    
                    //self.aData.append(data)
                    
                    self.searchedTableView.reloadData()
                }
            }
        }
    }
    
    func fetchKakaoLocalAPIData(text: String, x: String?, y: String?, page: String?) {
        print(#function)
        KakaoLocalAPIManager.shared.getKakaoLocalApiData(url: Constants.requestAPI.requestByAddressAndKeyword, keyword: text, x: x, y: y, page: page) { code, json in
            
            let countItem = json["meta"]["total_count"].intValue
            let page = json["meta"]["pageable_count"].intValue
            self.totalCount = countItem
            self.page = page
            
            //if countItem < 30 { // 열개 안 으로 조회될때 표출
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
            //}
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
        
        print("in :", locationManager.location?.coordinate ?? "")
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
        
        //cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        
        // mark
        cameraPositon = mapView.cameraPosition
        print("cameraPosition : ", cameraPositon)
        
        setMarker(lat: cameraPositon.target.lat, lng: cameraPositon.target.lng)
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
    
    func setMarker(lat: Double, lng: Double) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.mapView = mapView
        
        let infoWindow = NMFInfoWindow()
        //        let dataSource = NMFInfoWindowDefaultTextSource.data()
        //        infoWindow.dataSource = dataSource
        
        infoWindow.open(with: marker)
    }
    
}

//MARK: - ResultTableViewDelegate

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
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
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("am i end?")
        searchedTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected : ", indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if aData.count - 1 == indexPath.row {
                page += 1
                fetchKakaoLocalAPIData(text: self.searchText, x: nil, y: nil, page: String(page))
                print("indexPath: \(indexPath)", page)
                // 서버에 요청
            } else if page == totalCount {
                print("end")
            }
        }
    }
    
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

