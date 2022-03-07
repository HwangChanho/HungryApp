//
//  UserDefaultManager.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/28.
//

import Foundation

struct User: Codable {
    var id: String = ""
    var pass: String = ""
    var index: Int = 0
    var phoneNum: String = ""
    var name: String = ""
    var saveEmailCheck: Bool = false
    var autoLoginCheck: Bool = false
}

final class UserDefaultManager {
    static let shared  = UserDefaultManager()
    
    var user = User()
    
    init() {
        load()
    }
    
    func save() {
        do {
            let userData = try JSONEncoder().encode(user)
            
            UserDefaults.standard.set(userData, forKey: Constants.userDefaultKey.userInfo)
            UserDefaults.standard.synchronize()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() {
        do {
            if let data = UserDefaults.standard.data(forKey: Constants.userDefaultKey.userInfo) {
                let decoded = try JSONDecoder().decode(User.self, from: data)
                user = decoded
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
