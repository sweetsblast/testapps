//
//  AppDelegate.swift
//  testapps
//
//  Created by 志村晃央 on 2016/12/03.
//  Copyright © 2016年 志村晃央. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // 起動処理が始まったが、まだ状態の復元は始まっていない段階
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("launchOptions:%@", launchOptions ?? "nil")
        
        return true;
    }
    
    // 起動処理が終わり、状態の復元が始まって、アプリのウィンドウと他のUI部品が表示される前
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("launchOptions:%@", launchOptions ?? "nil")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            // Enable or disable features based on authorization.
            if granted == true
            {
                print("Allow")
                UIApplication.shared.registerForRemoteNotifications()
            }
            else
            {
                print("Don't Allow")
            }
        }
        
        // DropBox setup
        DropboxClientsManager.setupWithAppKey("7qdfypwqs8ballp")
        
        return true
    }
    
    // アプリがInactiveからActiveになった時
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("***" + #function)
        NSLog("application:%@",application.description)
    }

    // アプリがActiveからInacriveになる直前
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("***" + #function)
        NSLog("application:%@",application.description)
    }

    // URLスキームで呼び出された際に呼ばれる（iOS9まで）
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("url:%@", url.description)
        NSLog("sourceApplication:%@", sourceApplication ?? "nil")
        print(annotation)
        
        return true
    }
    // URLスキームで呼び出された際に呼ばれる（iOS9以降）
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("url:%@", url.description)
        NSLog("options:%@", options)
        
        // DropBox のURLスキーム処理
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
            case .cancel:
                print("User canceld OAuth flow.")
            case .error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
        
        return true
    }

    // メモリ圧迫時に呼ばれる
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("***" + #function)
        NSLog("application:%@",application.description)
    }
    
    // アプリが終了する直前に呼ばれる
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("***" + #function)
        NSLog("application:%@",application.description)
    }

    // 大幅な時刻変更があった場合に呼ばれる
    func applicationSignificantTimeChange(_ application: UIApplication) {
        print("***" + #function)
        NSLog("application:%@",application.description)
    }

    // ステータスバーの向きが変わる直前に呼ばれる
    func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("willChangeStatusBarOrientation:%@",newStatusBarOrientation.rawValue)
        NSLog("duration:%@",duration)
    }
    
    // ステータスバーの向きが変わった時に呼ばれる
    func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("didChangeStatusBarOrientation:%@",oldStatusBarOrientation.rawValue)
    }
    
    // ステータスバーのframeが変更される直前に呼ばれる
    func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("willChangeStatusBarFrame:%@",newStatusBarFrame.debugDescription)
    }
    // ステータスバーのframeが変更された直後に呼ばれる
    func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("didChangeStatusBarFrame:%@",oldStatusBarFrame.debugDescription)
    }
    
    // アプリ起動時に呼ばれ、どの種類のユーザ通知の利用が許可されているかを得るために使う
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("didRegister:%@",notificationSettings.description)
    }
    
    // Push通知の登録が完了した場合、deviceTokenが返される
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        let tokenText = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("deviceToken = \(tokenText)")
    }
    
    // Push通知が利用不可であればerrorが返ってくる
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("error: " + "\(error)")
    }
    
    // アプリがリモート通知を受け取った時に呼ばれる
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("***" + #function)
        NSLog("application:%@",application.description)
        NSLog("userInfo:%@",userInfo)
        switch application.applicationState {
        case .inactive:
            // アプリがバックグラウンドにいる状態で、Push通知から起動したとき
            break
        case .active:
            // アプリ起動時にPush通知を受信したとき
            break
        case .background:
            // アプリがバックグラウンドにいる状態でPush通知を受信したとき
            break
        }
    }

    // アプリがバックグラウンドに入った直後に呼ばれる
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("***" + #function)
    }

    // アプリがフォアグラウンドに入る直前に呼ばれる
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("***" + #function)
    }
}

