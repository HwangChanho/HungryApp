//
//  DetainInfoCollectionViewCell.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/26.
//

import UIKit

class DetailInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailInfoCollectionViewCell"
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeURLButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageLabel.backgroundColor = .gray
        imageLabel.image = UIImage(systemName: "xmark")
    }

    @IBAction func urlButtonPressed(_ sender: UIButton) {
        
    }
}
