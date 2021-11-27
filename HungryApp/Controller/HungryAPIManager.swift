//
//  HungryAPIManager.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/27.
//

import Foundation

import Alamofire
import SwiftyJSON
import UIKit

class HungryAPIManager {
    
    static let shared = HungryAPIManager()
    
    typealias CompletionHandler = (Int, JSON) -> ()
    
    func getIdPwdApiData(option: String, id: String, pass: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/" + option
        
        AF.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    let code = response.response?.statusCode ?? 500
                    
                    result(code, json)
                    
                case .failure(let error): // 네트워크 통신 실패시
                    print(error)
            }
        }

    }
    
    func getHungryApiData(option: String, result: @escaping CompletionHandler) {
        
        let url = Constants.requestAPI.requestByIP + "/" + option
        
        AF.request(url, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    let code = response.response?.statusCode ?? 500
                    
                    result(code, json)
                    
                case .failure(let error): // 네트워크 통신 실패시
                    print(error)
            }
        }
    }
    
//    func postHungryApiData(option: String, data: addressDataByKeyworld, image: [UIImage], result: @escaping CompletionHandler) {
//
//        let url = Constants.requestAPI.requestByIP + "/" + option
//
//        guard let imageData = image[0].pngData() else { return } // 이미지 파일 포맷
//
//
//
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData, withName: "image", fileName: "myImage")
//        }, to: Endpoint.visionURL, headers: header)
//            .validate(statusCode: 200...500)
//            .responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                let code = response.response?.statusCode ?? 500
//
//                result(code, json)
//
//            case .failure(let error): // 네트워크 통신 실패시
//                print(error)
//            }
//        }
//    }
}
