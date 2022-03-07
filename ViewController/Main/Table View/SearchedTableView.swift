//
//  SearchedTableView.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/24.
//

import UIKit

class DynamicHeightTableView: UITableView {
    
    var isDynamicSizeRequired = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != self.intrinsicContentSize {
            if self.intrinsicContentSize.height > frame.size.height {
                self.invalidateIntrinsicContentSize()
            }
        }

        if isDynamicSizeRequired {
            self.invalidateIntrinsicContentSize()
        }

    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
