//
//  Serializable.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 08/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

protocol Serializable: Codable {
    func serialize() -> Data?
}

extension Serializable {
    func serialize() ->Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
