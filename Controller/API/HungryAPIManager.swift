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
    typealias StringCompletionHandler = (Int, String) -> ()
    typealias FailHandler = (Error) -> ()
    
    //MARK: - Image
    
    func postImageData(images: UIImage, result: @escaping StringCompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/file"
        
        let header : HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Content-Type": "image/png"
        ]
        
        let size = CGSize(width: 200, height: 200)
        let resizedImage = images.resized(to: size)
        
        //let resizedImage = images.resize(newWidth: 200)
        
        guard let imageData = resizedImage!.pngData() else { return } // 이미지 파일 포맷
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "\(imageData).png", mimeType: "image/png")
        }, to: url, headers: header)
            .validate(statusCode: 200...500)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    let string = value
                    let code = response.response?.statusCode ?? 500
                    
                    print("return photo url : ", string)
                    result(code, string)
                case .failure(let error): // 네트워크 통신 실패시
                    print(error)
                }
            }
    }
    
    //MARK: - Store
    
    func deleteStoreData(storeID: Int, result: @escaping CompletionHandler, failResult: @escaping FailHandler) {
        let url = Constants.requestAPI.requestByIP + "/store/\(storeID)"
        
        AF.request(url, method: .delete, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    let code = response.response?.statusCode ?? 500
                    
                    result(code, json)
                    
                case .failure(let error): // 네트워크 통신 실패시
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    failResult(error)
                }
            }
    }
    
    // 유저 인덱스와 카테고리로 스토어정보 불러오기, 카테고리가 없을경우 유저인덱스 기준으로 불러온다.
    func getAllStoreByUserIndexAndCategory(index: String, category: String?, result: @escaping CompletionHandler, failResult: @escaping FailHandler) {
        let url = Constants.requestAPI.requestByIP + "/stores"
        
        var parameters: [String: Any] = [:]
        parameters = ["user_id": index]
        
        if category != nil {
            parameters = [
                "user_id": index,
                "category": category!
            ]
        }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    let code = response.response?.statusCode ?? 500
                    
                    result(code, json)
                    
                case .failure(let error): // 네트워크 통신 실패시
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    failResult(error)
                }
            }
    }
    
    func postStoreData(storeData: addressDataByKeyworld?, index: Int, photoURL: [String], result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/store/"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        var photo: [[String: Any]] = []
        let user: [String: Any] = ["id": index]
        
        if photoURL.count == 0 {
            photo = [["path": ""]]
        } else {
            photo = []
            
            for i in 0 ..< photoURL.count {
                photo.append(["path": photoURL[i]])
            }
        }
        
        // POST 로 보낼 정보
        let params = [
            "name": storeData?.place_name ?? "",
            "addressName": storeData?.address_name ?? "",
            "description": storeData?.review ?? "",
            "rating": storeData?.rating ?? 0,
            "location": storeData?.address_name ?? "",
            "category": storeData?.category ?? 0,
            "user": user,
            "photo": photo
        ] as [String: Any]
        
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let code = response.response?.statusCode ?? 500
                
                result(code, json)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func putStoreDataByIndex(storeData: addressDataByKeyworld?, storeIndex: Int, userIndex: Int, result: @escaping CompletionHandler, failResult: @escaping FailHandler) {
        let url = Constants.requestAPI.requestByIP + "/store"
        
        let user: [String: Any] = ["id": userIndex]
        
        var photo: [[String: Any]] = []
        
        if storeData?.photo?.count == 0 {
            photo = [["path": ""]]
        } else {
            photo = []
            
            for i in 0 ..< (storeData?.photo!.count)! {
                photo.append(["path": storeData?.photo?[i]])
            }
        }
        
        let param = [
            "id": storeIndex,
            "name": storeData?.place_name ?? "",
            "review": storeData?.review ?? "",
            "rating": storeData?.rating ?? 0,
            "addressName": storeData?.address_name ?? "",
            "categoryGroupName": storeData?.category_group_name ?? "",
            "categoryGroupCode": storeData?.category_group_code ?? "",
            "phone": storeData?.phone ?? "",
            "placeName": storeData?.place_name ?? "",
            "placeUrl": storeData?.place_url ?? "",
            "roadAddressName": storeData?.road_address_name ?? "",
            "x": storeData?.x ?? 0,
            "y": storeData?.y ?? 0,
            "category": storeData?.category ?? "한식",
            "photo": photo,
            "user": user
        ] as [String: Any]
        
        AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ... 500)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let code = response.response?.statusCode ?? 500
                    
                    result(code, json)
                    
                case .failure(let error): // 네트워크 통신 실패시
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    failResult(error)
                }
            }
    }
    
    func getStoreById(storeIndex: Int, result: @escaping CompletionHandler, failResult: @escaping FailHandler) {
        let url = Constants.requestAPI.requestByIP + "/store/\(storeIndex)"
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200 ... 500)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let code = response.response?.statusCode ?? 500
                    
                    result(code, json)
                    
                case .failure(let error): // 네트워크 통신 실패시
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                    failResult(error)
                }
            }
    }
    
    //MARK: - Login
    
    func postLoginData(email: String, pass: String, result: @escaping CompletionHandler, failResult: @escaping FailHandler) {
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
                failResult(error)
            }
        }
    }
    
    func getEmail(email: String?, phone: String, result: @escaping CompletionHandler) {
        var option = ""
        
        if email == nil {
            option = "/find-email?phone=" + phone
        } else {
            option = "/find-password?email=" + email! + "&phone=" + phone
        }
        
        let url = Constants.requestAPI.requestByIP + "/user" + option
        
        print(#function, url)
        
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
    
    func getAllID(result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/users"
        
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
    
    func postIdPwdApiData(email: String, pass: String, name: String, phone: String, result: @escaping CompletionHandler, failResult: @escaping FailHandler) {
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
                print("🚫 Alamofire Request Error \nCode:\(error._code), \nMessage: \(error.errorDescription!)")
                failResult(error)
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
    
    func putUserImage(userId: Int, imagePath: String, result: @escaping CompletionHandler) {
        let url = Constants.requestAPI.requestByIP + "/user"
        
        let photoData: [String: Any] = ["path": imagePath]
        
        let param = [
            "id": userId,
            "photo": photoData
        ] as [String: Any]
        
        AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default)
            .validate(statusCode: 200...500)
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
