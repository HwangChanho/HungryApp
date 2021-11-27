//
//  KakaoLocalAPIController.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/23.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoLocalAPIManager {
    
    static let shared = KakaoLocalAPIManager()
    
    typealias CompletionHandler = (Int, JSON) -> ()
    
    func getKakaoLocalApiData(url: String, keyword: Any, result: @escaping CompletionHandler) {
        
        let header: HTTPHeaders = [
            "Authorization": Constants.kakaoAK.ID,
            "Content-Type": "multipart/form-data"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: header)
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
    
    func getKakaoLocalApiData(url: String, keyword: Any, x: String?, y: String?, page: String?, result: @escaping CompletionHandler) {
        let header: HTTPHeaders = [
            "Authorization": Constants.kakaoAK.ID,
            "Content-Type": "multipart/form-data"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
        ]
        
        let radius = 50000
        var formattedURL = ""
        var paging = ""
        
        if page != nil {
            paging = page!
        }
        
        formattedURL = url + "?page=" + paging
        
        if (x != nil) && (y != nil) {
            formattedURL = url + "&y=" + y! + "&x=" + x! + "&radius=" + String(radius)
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            AF.request(formattedURL, method: .get, parameters: parameters, headers: header)
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
    }
}


