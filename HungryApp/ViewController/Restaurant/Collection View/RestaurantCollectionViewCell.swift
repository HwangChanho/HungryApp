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
    
    var buttonActionHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterButton.backgroundColor = .clear
        filterButton.setTitleColor(UIColor(named: "Color"), for: .normal)
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        buttonActionHandler?()
    }
    
}
