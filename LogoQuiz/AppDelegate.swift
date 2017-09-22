//
//  AppDelegate.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UIApplication.shared.statusBarStyle = .lightContent
        RewardAdManager.instance.loadAd()
        Fabric.with([Crashlytics.self])
        BrandManager.decodeJSON { (stored) in
            if stored {
                //dissmiss splash screen here
            }
        }
        
        CashProducts.store.requestProducts { (_, _) in }
        
        let ud = UserDefaults.standard
        if ud.object(forKey: Constants.firstLaunch) == nil {
            ud.set(1000, forKey: Constants.cash)
            ud.set(false, forKey: Constants.firstLaunch)
        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, _) in
            Messaging.messaging().delegate = self
        }
        application.registerForRemoteNotifications()
        
        return true
    }

    //MARK: Push Notifications
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("The device has FCM token: '\(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}


