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
    private(set) var gameState: GameState {
        didSet{
            GameStateManager.gameStates[brandLevel] = gameState
        }
    }
    
    var isDone: Bool {
        get {
            return gameState.isDone
        }
        mutating set {
            gameState.isDone = newValue
        }
    }
    
    var hasRemovedLetters: Bool {
        get {
            return gameState.hasRemovedLetters
        }
        mutating set {
            gameState.hasRemovedLetters = newValue
        }
    }
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
    
    var foundLetters: [[String]] {
        return gameState.lettersFound
    }
    var shouldHideFindButton: Bool {
        return foundLetters.joined().filter({$0 == " "}).count <= 1
    }
    
    //TODO: Refactor me!!!!!!
    mutating func getCorrectLetter() -> [IndexPath : Character] {
        let randomChar = randomLetter(from: gameState.helperLetters.filter({$0 != "|"}).joined())
        guard randomChar != " " else { return getCorrectLetter() }
        var words = gameState.helperLetters.split(separator: " ").map({Array($0)})
        let index: IndexPath
        if let indx = words[0].index(of: String(randomChar)){
            index = IndexPath(row: 0, section: indx)
        }else if let indx = words[1].index(of: String(randomChar)) {
            index = IndexPath(row: 1, section: indx)
        }else {
            return getCorrectLetter()
        }
        
        words[index.row].remove(at: index.section)
        words[index.row].insert("|", at: index.section)
        gameState.lettersFound[index.row].remove(at: index.section)
        gameState.lettersFound[index.row].insert(String(randomChar), at: index.section)
        if words.count > 1 {
            gameState.helperLetters = Array(words[0] + [" "] + words[1]).map({String($0)})
        }else {
            gameState.helperLetters = Array(words[0]).map({String($0)})
        }
        if shouldHideFindButton {
            NotificationCenter.default.post(name: Notifications.hideFindButton, object: nil)
        }
        return[index: randomChar]
    }
    
    fileprivate func randomLetter(from: String? = nil) -> Character {
        let a = from == nil ? "ABCDEFGHIJKLMNOPQRSTUVWXYZ" : from
        let r = Int(arc4random_uniform(UInt32(a!.characters.count)))
        return String(a![a!.index(a!.startIndex, offsetBy: r)]).characters.first!
    }
    
    init(brand: Brand) {
        self.brand = brand
        let initialLettersFound = brand.name.components(separatedBy: " ").map({$0.characters.map({ _ in " "})})
        let initialHelperChars = Array(brand.name.characters).map{String($0)}
        self.gameState = GameStateManager.gameStates[brand.level] ?? GameState(hasRemovedLetters: false, lettersFound: initialLettersFound, helperLetters: initialHelperChars, isDone: false)
    }
}
