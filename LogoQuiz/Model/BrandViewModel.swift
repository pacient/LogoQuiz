//
//  BrandViewModel.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

struct BrandViewModel {
    private(set) var brand: Brand
    
    var brandName: String {
        return brand.name
    }
    
    var imageName: String {
        return brand.imageName
    }
    
    var brandLevel: Int {
        return brand.level
    }
    
    var lettersToShow: [Character] {
        var charArray = [Character]()
        for char in brandName { // Get first the letters that are in the actual word
            if char != " " {
                charArray.append(char)
            }
        }
        for _ in charArray.count..<20 { //Now add random letters to it
            charArray.append(randomLetter())
        }
        charArray.shuffle()
        return charArray
    }
    
    fileprivate func randomLetter() -> Character {
        let a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let r = Int(arc4random_uniform(UInt32(a.characters.count)))
        return String(a[a.index(a.startIndex, offsetBy: r)]).characters.first!
    }
    
    init(brand: Brand) {
        self.brand = brand
    }
}
