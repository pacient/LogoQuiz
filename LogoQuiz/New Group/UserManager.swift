//
//  UserManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class UserManager {
    private static let instance = UserManager()
    static var levelsCompleted: Int {
        return UserDefaults.standard.integer(forKey: Constants.levelsCompleted)
    }
    static var cash: Int {
        return UserDefaults.standard.integer(forKey: Constants.cash)
    }
    static var brandToFind: Brand? {
        return BrandManager.brands.filter({$0.level == UserManager.levelsCompleted+1}).first
    }
}
