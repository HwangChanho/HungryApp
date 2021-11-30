//
//  RestaurantViewController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/21.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let foodcate = FoodCategory()
    
    var aData: [addressDataByKeyworld] = []
    var selectedData: addressDataByKeyworld?
    var nowUser = UserDefaultManager.shared.user.index
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setNib()
        setTableView()
        // setNavigation()
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "Color")
    }
    
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
        let firstBarItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addButtonPressed(_:)))
        
        var rightBarButtons: [UIBarButtonItem] = []
        rightBarButtons.append(firstBarItem)
        self.navigationItem.rightBarButtonItems = rightBarButtons
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Color")
    }
    
    // navigation 버튼
    @objc func addButtonPressed(_ sender: UIButton) {
        
    }
    
    func getUserDataFromDB() {
        HungryAPIManager.shared.getAllStoreByUserIndexAndCategory(index: nowUser, category: nil) { code, json in
            print(code, json)

            switch(code) {
            case 200:
                let result = json["result"].stringValue
                print(result)
                if result == "FAILURE" {
                } else {
                }
            case 400:
                print("error")
            default:
                print("ERROR")
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
        
        cell.filterButton.setTitle(row, for: .normal)
        cell.buttonActionHandler = {
            // row 값을 서버에 전송하여 필터링된 데이터를 받아옴
            print(row)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier, for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = "test"
        cell.locationLabel.text = "test1"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Register", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        
        vc.searchText = "korean"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // let row = aData[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            // DB제거
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
