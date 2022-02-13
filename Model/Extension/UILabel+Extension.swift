//
//  UILabel+Extension.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/28.
//

import UIKit

extension UILabel {
    
    func disappearLabel(delay: Double, text: String) {
        self.text = text
        
        UIView.animate(withDuration: 2.0, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = 0.0 }, completion: {(isCompleted) in
                // self.text = ""
                // self.isHidden = true
                self.isHidden = true
            })
    }
    
}



