//
//  addressData.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/24.
//

import Foundation

struct addressData {
    let address_name: String
    let x: String
    let y: String
    let road_name: String?
}

struct addressDataByKeyworld {
    var address_name: String?
    var category_group_name: String?
    var category_group_code: String?
    var phone: String?
    var place_name: String?
    var place_url: String?
    var road_address_name: String?
    var x: Double = 0
    var y: Double = 0
    var category: String?
    var rating: Double = 0
    var review: String?
    var photo: [String]?
}

