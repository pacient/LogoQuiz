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
    static var brands = [Brand]()
    
    class func decodeJSON(_ completion: (Bool)->Void) {
        guard let path = Bundle.main.url(forResource: "app", withExtension: "json") else {return}
        do {
            let data = try Data(contentsOf: path)
            brands = try JSONDecoder().decode([Brand].self, from: data)
            completion(true)
        }catch let error {
            print(error.localizedDescription)
            completion(false)
        }
    }
}
