//
//  RestaurantTableViewCell.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    static let identifier = "RestaurantTableViewCell"
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var starButton: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starButton.map{ $0.setTitle("", for: .normal) }
        
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.cornerRadius = 15
        backgroundImage.backgroundColor = .gray
        
        starButton.map{ $0.tintColor = UIColor(named: "Color") }
        
        bottomView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        mainView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = UIColor.orange.cgColor
            contentView.layer.cornerRadius = 15
            // bottomView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        } else {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
    }
}
