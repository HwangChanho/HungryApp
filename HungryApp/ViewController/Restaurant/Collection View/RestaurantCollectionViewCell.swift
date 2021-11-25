//
//  RestaurantCollectionViewCell.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/22.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RestaurantCollectionViewCell"

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterButton.backgroundColor = .clear
        filterButton.setTitleColor(.lightGray, for: .normal)
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        print("Pressed")
        
        if sender.isSelected {
            filterButton.layer.borderWidth = 3
            filterButton.layer.borderColor = UIColor.orange.cgColor
            filterButton.layer.cornerRadius = 15
            filterButton.backgroundColor = .orange
        } else {
            filterButton.layer.borderWidth = 1
            filterButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}
