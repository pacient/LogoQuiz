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
    static var delegate: GameHintDelegate?
    
    //MARK: Functions
    fileprivate class func noCashAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Ooops!", message: "You don't have enough 💵. Solve levels to get more 💵 or go to the menu to purchase more.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    class func resetProgressAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Warning!", message: "If you reset the progress your cash will be set to 💵1500 and you will be set back to level 1. Do you want to continue?", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            CashManager.resetCash()
            GameStateManager.gameStates = [:]
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
    
    class func removedLetters() {
        ud.set(true, forKey: Constants.hasRemovedLetters)
    }
    class func setValuesForNextLevel() {
        CashManager.bumpCash()
    }
    
    class func giveLetterHintAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Letter Hint", message: "Show correct letter for 💵60?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let purchased = CashManager.decreaseCash(for: .correctLetter)
            if purchased {
                self.delegate?.giveCorrectLetter()
            }else {
                UIApplication.shared.keyWindow?.rootViewController?.present(noCashAlert(), animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }
    
    class func removeLettersHintAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Remove Letters Hint", message: "Remove letters that are not part of the solution for 💵80?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let purchased = CashManager.decreaseCash(for: .removeLetter)
            if purchased {
                self.delegate?.removeLetters()
            }else {
                UIApplication.shared.keyWindow?.rootViewController?.present(noCashAlert(), animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }
    
    
}
