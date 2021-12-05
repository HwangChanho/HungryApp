//
//  RestaurantViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/21.
//

import UIKit
import Kingfisher

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView()
    let foodcate = FoodCategory()
    let handler: CompletionHandler? = nil
    var aData: [addressDataByKeyworld] = []
    var selectedData: addressDataByKeyworld?
    var storeIdField: [Int] = []
    var nowUser = 0
    var deleteStoreIndex = 0
    var buttonFlag = false
    
    override func viewWillAppear(_ animated: Bool) {
        getUserStoreDataFromDB(category: nil)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setNib()
        setTableView()
        // setNavigation()
        
        getUserDefaultsData()
        nowUser = UserDefaultManager.shared.user.index
        getUserStoreDataFromDB(category: nil)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
    }
    
    //MARK: - setUI
    
    func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setNib() {
        let nibName = UINib(nibName: RestaurantTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        
        let nibName2 = UINib(nibName: RestaurantCollectionViewCell.identifier, bundle: nil)
        self.collectionView.register(nibName2, forCellWithReuseIdentifier: RestaurantCollectionViewCell.identifier)
    }
    
    func setTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    func setCollectionView() {
        collectionView.tintColor = UIColor(named: "Color")
    }
    
    func setNavigation() {
        let firstBarItem = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonPressed(_:)))
        
        var leftBarButtons: [UIBarButtonItem] = []
        leftBarButtons.append(firstBarItem)
        navigationItem.leftBarButtonItems = leftBarButtons
        // navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - @objc
    
    // navigation 버튼
    @objc func mapButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - API
    
    func getUserStoreDataFromDB(category: String?) {
        HungryAPIManager.shared.getAllStoreByUserIndexAndCategory(index: String(nowUser), category: category) { code, json in
            switch code {
            case 200:
                let result = json["result"].stringValue
                let data = json["data"].arrayValue
                
                if result == "SUCCESS" {
                    self.storeIdField = []
                    self.aData = []
                    
                    for item in data {
                        self.storeIdField.append(item["id"].intValue)
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
                        
                        self.aData.append(data)
                    }
                    self.tableView.reloadData()
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
    
    func deleteStore() {
        HungryAPIManager.shared.deleteStoreData(storeID: deleteStoreIndex) { code, json in
            self.Log(json)
            self.Log(code)
            
            switch code {
            case 200:
                let result = json["result"].stringValue
                
                if result == "SUCCESS" {
                    self.showToast(message: "삭제 완료")
                } else {
                    self.showToast(message: "삭제 실패")
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
}

//MARK: - CollectionView

extension RestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodcate.pickerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = foodcate.pickerList[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as? RestaurantCollectionViewCell else { return UICollectionViewCell() }
        
        cell.filterButton.setTitleColor(UIColor(named: "Color"), for: .normal)
        cell.filterButton.backgroundColor = .clear
        cell.filterButton.setTitle(row, for: .normal)
        cell.buttonActionHandler = {
            // row 값을 서버에 전송하여 필터링된 데이터를 받아옴
            if indexPath.row == 0 {
                self.getUserStoreDataFromDB(category: nil)
            } else {
                self.getUserStoreDataFromDB(category: row)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 10, height: collectionView.bounds.height)
    }
}

//MARK: - TableView

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        
        let row = aData[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = row.place_name
        cell.locationLabel.text = row.address_name
        cell.categoryLabel.text = row.category
        cell.ratingLabel.text = "\(Int(row.rating))점"
        
        print("URL : ", row.photo![0])
        
        if let url = URL(string: row.photo![0]) {
            cell.backgroundImage.kf.setImage(with: url)
        } else {
            cell.backgroundImage.image = UIImage(named: "MainImage")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = aData[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        
        vc.selectedData = row
        vc.selectedFromRestarantFlag = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = aData[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            for i in 0 ..< self.aData.count {
                if self.aData[i].phone == row.phone && self.aData[i].place_url == row.place_url {
                    self.deleteStoreIndex = self.storeIdField[i]
                    
                    print("delete Action storeID : ", self.deleteStoreIndex)
                    
                    self.deleteStore()
                    self.drawIndicator(activityIndicator: self.activityIndicator, isActive: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                        self.getUserStoreDataFromDB(category: nil)
                    }
                    self.drawIndicator(activityIndicator: self.activityIndicator, isActive: false)
                    break
                }
            }
            completion(true)
        }
        
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
