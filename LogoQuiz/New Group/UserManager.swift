//
//  UserManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class UserManager {
    private static let instance = UserManager()
    private static let ud = UserDefaults.standard
    static var levelsCompleted: Int {
        return ud.integer(forKey: Constants.levelsCompleted)
    }
    static var cash: Int {
        return ud.integer(forKey: Constants.cash)
    }
    static var brandToFind: Brand? {
        return BrandManager.brands.filter({$0.level == UserManager.levelsCompleted+1}).first
    }
    static var cashString: String {
        return "💵\(cash)"
    }
    
    class func resetProgressAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Warning!", message: "If you reset the progress your cash will be set to 💵1500 and you will be set back to level 1. Do you want to continue?", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            ud.set(1500, forKey: Constants.cash)
            ud.set(0, forKey: Constants.levelsCompleted)
            NotificationCenter.default.post(name: Notifications.updateCash, object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(continueAction)
        alert.addAction(cancelAction)
        return alert
    }
}
