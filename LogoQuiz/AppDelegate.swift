//
//  AppDelegate.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UIApplication.shared.statusBarStyle = .lightContent
        
        RewardAdManager.instance.loadAd()
        
        BrandManager.decodeJSON { (stored) in
            if stored {
                //dissmiss splash screen here
            }
        }
        
        CashProducts.store.requestProducts { (_, _) in }
        
        let ud = UserDefaults.standard
        
        if ud.object(forKey: Constants.firstLaunch) == nil {
            ud.set(0, forKey: Constants.levelsCompleted)
            ud.set(1500, forKey: Constants.cash)
            ud.set(false, forKey: Constants.firstLaunch)
        }
        
        return true
    }
}

