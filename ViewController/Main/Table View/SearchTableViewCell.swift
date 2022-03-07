//
//  SearchTableViewCell.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
    @IBOutlet weak var searchedLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchedLabel.font = .boldSystemFont(ofSize: 15)
        detailLabel.font = .systemFont(ofSize: 12)
        categoryLabel.font = .systemFont(ofSize: 12)
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


