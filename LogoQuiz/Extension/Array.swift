//
//  Array.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

extension Array {
    public mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let random = Int(arc4random_uniform(UInt32(i+1)))
            if i != random {
                self.swapAt(i, random)
            }
        }
    }
}
