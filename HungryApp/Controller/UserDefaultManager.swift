//
//  UserDefaultManager.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/28.
//

import Foundation

struct UserInfo: Codable {
    var id: String?
    var pass: String?
}

final class UserDefaultManager {
    static let shared  = UserDefaultManager()
    
    var user: UserInfo?
    
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
                let decoded = try JSONDecoder().decode(UserInfo.self, from: data)
                user = decoded
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
