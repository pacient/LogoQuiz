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
    
    private var helperChars: [String]
    
    //TODO: Refactor me!!!!!!
    mutating func getCorrectLetter() -> [String : Character] {
        let randomChar = randomLetter(from: helperChars.filter({$0 != "|"}).joined())
        guard randomChar != " " else { return getCorrectLetter() }
        var words = helperChars.split(separator: " ")
        var i = 0
        var index: Int
        if let indx = words[0].index(of: String(randomChar)){
            i = 0
            index = indx
        }else if let indx = words[1].index(of: String(randomChar)) {
            i = 1
            index = indx
        }else {
            return getCorrectLetter()
        }
        words[i].remove(at: index)
        words[i].insert("|", at: index)
        if words.count > 1 {
            self.helperChars = Array(words[0] + [" "] + words[1]).map({String($0)})
        }else {
            self.helperChars = Array(words[0]).map({String($0)})
        }
        if helperChars.filter({$0 != "|" && $0 != " "}).joined().count == 1 {
            NotificationCenter.default.post(name: Notifications.hideFindButton, object: nil)
        }
        let keyToReturn = i == 1 ? "\(i)\(index - words[0].count - 1)" : "\(i)\(index)"
        return[keyToReturn: randomChar]
    }
    
    fileprivate func randomLetter(from: String? = nil) -> Character {
        let a = from == nil ? "ABCDEFGHIJKLMNOPQRSTUVWXYZ" : from
        let r = Int(arc4random_uniform(UInt32(a!.characters.count)))
        return String(a![a!.index(a!.startIndex, offsetBy: r)]).characters.first!
    }
    
    init(brand: Brand) {
        self.brand = brand
        self.helperChars = Array(brand.name.characters).map{String($0)}
    }
}
