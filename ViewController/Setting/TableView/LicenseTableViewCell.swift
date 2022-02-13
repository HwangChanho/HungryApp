//
//  LicenseTableViewCell.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/12/02.
//

import UIKit

class LicenseTableViewCell: UITableViewCell {
    
    static let identifier = "LicenseTableViewCell"
        
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var link: UIButton!
    
    var buttonActionHandler: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        link.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func linkButtonPressed(_ sender: UIButton) {
        buttonActionHandler?()
    }
    
}
