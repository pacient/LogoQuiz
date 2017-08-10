//
//  InterstitialManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 10/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class InterstitialManager {
    private static let kViewCount = "InterstitialManager.viewCount"
    private static let adAfterViewCount = 6
    
    private(set) static var viewCount: Int = UserDefaults.standard.integer(forKey: kViewCount) {
        didSet {
            UserDefaults.standard.set(viewCount, forKey: kViewCount)
        }
    }
    
    class func resetViewCount() {
        viewCount = 0
    }
    class func trackViewCount() {
        viewCount += 1
    }
    
    class func shouldShowInterstitial() -> Bool {
        return viewCount >= adAfterViewCount
    }

}

private extension UserDefaults {
    func bool(forKey key: String, defaultValue: @autoclosure () -> Bool) -> Bool {
        if let value = object(forKey: key) as? Bool {
            return value
        } else {
            return defaultValue()
        }
    }
}

