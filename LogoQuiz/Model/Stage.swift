//
//  Stage.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/09/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

struct Stage: Decodable {
    let stage: Int
    let brands: [Brand]
    let toUnlock: Int
}
