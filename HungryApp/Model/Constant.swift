//
//  Constant.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/20.
//

import Foundation

struct Constants {
    
    static let baseURL: String = "com.HungryApp.HungryApp"
    
    struct requestAPI {
        static let requestByAddress = "https://dapi.kakao.com/v2/local/search/address.json"
        static let requestByAddressAndKeyword = "https://dapi.kakao.com/v2/local/search/keyword.json"
        static let requestByIP = "http://15.165.241.218:8080"
    }
    
    struct kakaoAK {
        static let ID = "KakaoAK e858a2f89adab39db1035f8f3acb2809"
    }
    
    struct userDefaultKey {
        static let userInfo = "USER_INFO"
    }
}
