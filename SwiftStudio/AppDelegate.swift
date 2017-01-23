//
//  AppDelegate.swift
//  SwiftStudio
//
//  Created by 유명식 on 2016. 12. 30..
//  Copyright © 2016년 swift. All rights reserved.
// -----------------------------------------------------------------------------------------------
//  변경 내역 적기
// -----------------------------------------------------------------------------------------------
//  2016.01.07 June Kang - 파이어베이스를 위한 설정 및 Main.storyborad연동 제거 (단, 경우에 따라서 다시 연결가능)
//
// -----------------------------------------------------------------------------------------------

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FireBase를 위한 설정
        FIRApp.configure()
        
        
        /*
         StoryBoard없이 연결할 경우 앱설정 (맨위 프로젝트 설정) -> General -> Main Interface (빈칸)
         놓은 상태에서 아래 코드와 같이 하면 됩니다.
         */
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible();
        
        let loginViewController = LoginViewController()
        let layout = UICollectionViewFlowLayout()
        let mainViewController = MainViewController(collectionViewLayout: layout)
        window?.rootViewController = loginViewController        
//        let naviContorller = UINavigationController(rootViewController: loginViewController)
//        naviContorller.navigationBar.isHidden = true; //네비게이션 바 숨기기
//        window?.rootViewController = naviContorller
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

