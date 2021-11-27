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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setNib()
        setTableView()
        
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
}

//MARK: - CollectionView

extension RestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionViewCell.identifier, for: indexPath) as? RestaurantCollectionViewCell else { return UICollectionViewCell() }
        
        cell.filterButton.setTitle("test", for: .normal)
        
        return cell
    }
    
    /* 수정 필요 */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let element = list[indexPath.row].userName

        let element = "test"
        let fontSize = 12
        let limit = 30
        let size = CGSize(width: collectionView.frame.width - 10, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))]
        let estimatedFrame = element.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let space = estimatedFrame.height - CGFloat(limit)
        
        print("collection view : ", collectionView.frame.width - 10)

        return CGSize(width: collectionView.frame.width - 10, height: 125 + space)
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
        return UIScreen.main.bounds.size.height / 2
    }
    
}
