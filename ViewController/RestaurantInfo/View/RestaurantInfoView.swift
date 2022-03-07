//
//  RestaurantInfoView.swift
//  HungryApp
//
//  Created by AlexHwang on 2021/12/29.
//

import Foundation
import UIKit
import SnapKit

class RestaurantInfoView: UIView {
    
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    let imageView4 = UIImageView()
    let imageView5 = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        [imageView1, imageView2, imageView3, imageView4, imageView5].forEach {
            $0.backgroundColor = .gray
            $0.layer.cornerRadius = 15
        }
    }
    
    func setupConstrains() {
        [imageView1, imageView2, imageView3, imageView4, imageView5].forEach {
            addSubview($0)
        }
    }
}
