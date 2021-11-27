//
//  AppDelegate.swift
//  HungryApp
//
//  Created by ChanhoHwang on 2021/11/20.
//

import UIKit
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
         //MARK: 탭 바 컨트롤러 생성 - 코드로 생성
         /*
         let tbC = UITabBarController()
         tbC.view.backgroundColor = .white
         
         //MARK: tbC를 루트 뷰 컨트롤러로 연결
         self.window?.rootViewController = tbC
         
         //MARK: 각 탭 바 아이템에 연결된 뷰 컨트롤러 객체를 생성
         let view01 = ViewController()
         let view02 = RestaurantViewController()
         let view03 = RegisterViewController()
         let view04 = SettingViewController()
         
         //MARK:  생성된 뷰 컨트롤러 객체에게 탭 바 컨트롤러를 등록
         tbC.setViewControllers([view01, view02, view03, view04], animated: false)
         
         //MARK: 개별 탭 바 아이템의 속성을 설정
         view01.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "house"), selectedImage: nil)
         view02.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "location"), selectedImage: nil)
         view03.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "plus"), selectedImage: nil)
         view04.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "human"), selectedImage: nil)
        */
         
        /*
        //MARK: 윈도우 객체에 연결된 루트뷰 컨트롤러를 읽어와 UITabBarController 로 캐스팅
        if let tbc = self.window?.rootViewController as? UITabBarController {
            
            //MARK: 탭 바로부터 탭 바 아이템 배열을 가져옴
            if let tbItems = tbc.tabBar.items {
                
                //탭 바 아이템에 이미지 등록
                tbItems[0].image = UIImage(named: "designbump")?.withRenderingMode(.alwaysOriginal)
                tbItems[1].image = UIImage(named: "rss")?.withRenderingMode(.alwaysOriginal)
                tbItems[2].image = UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal)
                
                
                //MARK: 탭바 선택했을때 표시
                //탭 바 아이템을 순회 하면서 selectedImage 속성에 이미지를 설정
                for tbItem in tbItems{
                    
                    let image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysOriginal)
                    
                    tbItem.selectedImage = image
                    
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.red], for: .selected)
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .disabled)
                    tbItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for: .normal)
                }
                
                //MARK: 탭 바 아이템에 타이틀을 설정
                tbItems[0].title = "calendar"
                tbItems[1].title = "file"
                tbItems[2].title = "photo"
                
            }
            
            //활성화된 탭 바 아이템의 이미지 색상을 변경
            //tbc.tabBar.tintColor = .white
            
            //탭 바에 배경 이미지를 설정
            tbc.tabBar.backgroundImage = UIImage(named: "menubar-bg-mini")
        }
        */
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

