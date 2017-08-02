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
        return BrandManager.brands.first(where: {$0.level == levelsCompleted+1})
    }
    static var cashString: String {
        return "💵\(cash)"
    }
    
    class func setValuesForNextLevel() {
        bumpCash()
        increaseLevel()
        resetFoundLettersForLevel()
    }
    
    fileprivate class func bumpCash() {
        ud.set(cash+5, forKey: Constants.cash)
    }
    
    fileprivate class func increaseLevel() {
        ud.set(levelsCompleted+1, forKey: Constants.levelsCompleted)
    }
    
    fileprivate class func resetFoundLettersForLevel() {
        ud.removeObject(forKey: Constants.foundLetters)
    }
    
    class func resetProgressAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Warning!", message: "If you reset the progress your cash will be set to 💵1500 and you will be set back to level 1. Do you want to continue?", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            ud.set(1500, forKey: Constants.cash)
            ud.set(0, forKey: Constants.levelsCompleted)
            resetFoundLettersForLevel()
            NotificationCenter.default.post(name: Notifications.updateCash, object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(continueAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    class func congratulationsAlert(completion: (()->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Congratulations 🎉", message: "You've completed all levels. Please keep the app updated for more levels.", preferredStyle: .alert)
        let action = UIAlertAction(title: "YAY!", style: .default) { (action) in
            completion?()
        }
        alert.addAction(action)
        return alert
    }
}
