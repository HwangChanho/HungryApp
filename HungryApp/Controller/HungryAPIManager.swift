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
    
    func getAllStoreByUserIndexAndCategory(index: String, category: String?, result: @escaping CompletionHandler) {
        var options = ""
        
        if category == nil {
            options = "user_id=" + index
        } else {
            options = "user_id=" + index + "&category=" + category!
        }
        
        let url = Constants.requestAPI.requestByIP + "/stores?" + options
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
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
    
    func getStoreByStoreIndex(index: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/store/" + index
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
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
    
    func getEmail(email: String?, phone: String, result: @escaping CompletionHandler) {
        var option = ""
        if email == nil {
            option = "/find-email"
        } else {
            option = "/find-password"
        }
        
        let url = Constants.requestAPI.requestByIP + "/user" + option
        
        let param = [
            "phone": phone
        ]
        
        AF.request(url, method: .get, parameters: param, encoding: JSONEncoding.default)
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
    
    func getAvailableEmail(email: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/check-email" + "?email=" + email
        
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
    
    func getAvailablePhoneNum(phoneNum: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/check-phone" + "?phone=" + phoneNum
        
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
    
    func getUserByID(id: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/user/" + id
        
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
    
    func postIdPwdApiData(email: String, pass: String, name: String, phone: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/user"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["name": name, "email": email, "phone": phone, "password": pass] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("postIdPwdApiData 성공")
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func postAddressData(data: addressDataByKeyworld, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/user"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["name": name, "email": email, "phone": phone, "password": pass] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("postIdPwdApiData 성공")
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func postLoginData(email: String, pass: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/login"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["email": email, "password": pass] as Dictionary
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print("postLoginData 성공")
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
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
