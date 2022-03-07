//
//  UIView+Extension.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/22.
//

import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
