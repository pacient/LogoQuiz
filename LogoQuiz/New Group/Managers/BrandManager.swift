//
//  BrandManager.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class BrandManager {
    private static let instance = BrandManager()
    static var stages = [Stage]()
    static var foundLogos: Int {
        return GameStateManager.gameStates.filter{$0.value.isDone == true}.count
    }
    
    class func decodeJSON(_ completion: (Bool)->Void) {
        guard let path = Bundle.main.url(forResource: "stages", withExtension: "json") else {return}
        do {
            let data = try Data(contentsOf: path)
            stages = try JSONDecoder().decode([Stage].self, from: data)
            completion(true)
        }catch let error {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
}
