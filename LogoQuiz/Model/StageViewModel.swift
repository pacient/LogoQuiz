//
//  StageViewModel.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/09/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

struct StageViewModel {
    private(set) var stage: Stage
    
    var brands: [Brand] {
        return stage.brands
    }
    var stageNumber: Int {
        return stage.stage
    }
    var toUnlockStage: Int {
        return stage.toUnlock
    }
}
