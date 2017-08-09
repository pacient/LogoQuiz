//
//  GameStateManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 08/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation


class GameStateManager {
    private init(){}
    
    static var gameStates: [Int: GameState] = fetch() {
        didSet {
            store(gameStates)
        }
    }
    
    private static func fetch() -> [Int: GameState] {
        guard let dict = UserDefaults.standard.dictionary(forKey: Constants.gameStates) else { return [:] }
        
        var result: [Int: GameState] = [:]
        let decoder = JSONDecoder()
        for (level, gameStateData) in dict {
            result[Int(level)!] = try? decoder.decode(GameState.self, from: gameStateData as! Data)
        }
        return result
    }
    
    private static func store(_ gameStates: [Int: GameState]) {
        var gameStatesData: [String: Data] = [:]
        let encoder = JSONEncoder()
        for (level, gameState) in gameStates {
            gameStatesData["\(level)"] = try? encoder.encode(gameState)
        }
        UserDefaults.standard.set(gameStatesData, forKey: Constants.gameStates)
    }}
