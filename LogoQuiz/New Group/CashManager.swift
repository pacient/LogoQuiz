//
//  CashManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 03/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

enum HintCost: Int {
    case correctLetter = 60
    case removeLetter = 80
}

class CashManager: NSObject {
    
    static let instance = CashManager()
    private static let ud = UserDefaults.standard
    
    private(set) var oldCash: Int?
    @objc private(set) dynamic var cash: Int = CashManager.ud.integer(forKey: Constants.cash) {
        didSet{
            oldCash = oldValue
            CashManager.ud.set(cash, forKey: Constants.cash)
        }
    }
    
    class func bumpCash(amount: Int = 5) {
        instance.cash += amount
    }
    
    class func decreaseCash(for hint: HintCost) -> Bool {
        guard instance.cash -  hint.rawValue >= 0 else {return false}
        instance.cash -= hint.rawValue
        return true
    }
    
    class func resetCash() {
       instance.cash = 1500
    }
    
    
}
