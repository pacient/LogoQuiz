//
//  AppDelegate.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        BrandManager.decodeJSON { (stored) in
            if stored {
                print(BrandManager.brands)
            }
        }
        
        let ud = UserDefaults.standard
        ud.set(0, forKey: Constants.levelsCompleted)

        if ud.object(forKey: Constants.firstLaunch) == nil {
            ud.set(0, forKey: Constants.levelsCompleted)
            ud.set(1500, forKey: Constants.cash)
            ud.set(false, forKey: Constants.firstLaunch)
        }
        
        return true
    }
}

