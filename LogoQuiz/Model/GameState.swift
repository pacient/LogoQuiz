//
//  GameState.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 08/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

struct GameState: Serializable {
    var hasRemovedLetters: Bool = false
    var lettersFound: [[String]] = []
    var isDone: Bool = false
}
