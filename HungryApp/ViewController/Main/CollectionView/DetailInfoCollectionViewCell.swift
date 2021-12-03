//
//  DetainInfoCollectionViewCell.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/26.
//

import UIKit

class DetailInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailInfoCollectionViewCell"
    
    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeURLButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    var buttonActionHandler: (() -> ())?
    var phoneButtonActionHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainVIew.backgroundColor = UIColor(named: "ColorAlpha")
        mainVIew.alpha = 0.8
        
        imageLabel.backgroundColor = .gray
        imageLabel.image = UIImage(systemName: "xmark")
        imageLabel.layer.cornerRadius = 15
        
        placeNameLabel.font = .boldSystemFont(ofSize: 20)
        
        categoryNameLabel.font = .systemFont(ofSize: 15)
        
        addressLabel.font = .systemFont(ofSize: 15)
        
        imageButton.setTitle("", for: .normal)
        
        phoneButton.setTitle("", for: .normal)
        phoneButton.titleLabel?.textAlignment = .left
        phoneButton.titleLabel?.font = .systemFont(ofSize: 13)
    }
    
    @IBAction func urlButtonPressed(_ sender: UIButton) {
        buttonActionHandler?()
    }
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        phoneButtonActionHandler?()
    }
}
