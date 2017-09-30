//
//  UserManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let instance = UserManager()
    private static let ud = UserDefaults.standard
    static var delegate: GameHintDelegate?
    @objc private(set) dynamic var isSoundDisabled: Bool = UserManager.ud.bool(forKey: Constants.audioDisabled) {
        didSet{
            UserManager.ud.set(isSoundDisabled, forKey: Constants.audioDisabled)
        }
    }
    
    //MARK: Functions
    fileprivate class func noCashAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Ooops!", message: "You don't have enough 💵. Solve levels to get more 💵 or purchase more now.", style: .alert, cancelText: "OK")
        let action = UIAlertAction(title: "Purchase Now!", style: .default) { (_) in
            guard let vc = UIApplication.shared.keyWindow?.rootViewController else {return}
            vc.presentProducts()
        }
        alert.addAction(action)
        return alert
    }
    
    class func resetProgressAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Warning!", message: "If you reset the progress your cash will be set to 💵\(CashManager.instance.startingCash) and you will lose the whole progress so far.", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Reset", style: .destructive) { (action) in
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
        let alert = UIAlertController(title: "Letter Hint", message: "Show correct letter for 💵\(HintCost.correctLetter.rawValue)?", preferredStyle: .alert)
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
        let alert = UIAlertController(title: "Remove Letters Hint", message: "Remove letters that are not part of the solution for 💵\(HintCost.removeLetter.rawValue)?", preferredStyle: .alert)
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
    
    class func toggleAudio() {
        instance.isSoundDisabled = !instance.isSoundDisabled
    }
}
