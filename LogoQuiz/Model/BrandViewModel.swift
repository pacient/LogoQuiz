//
//  BrandViewModel.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import Foundation

class BrandViewModel {
    private var brand: Brand
    
    var brandName: String {
        return brand.name
    }
    
    var imageName: String {
        return brand.imageName
    }
    
    var brandLevel: Int {
        return brand.level
    }
    
    init(brand: Brand) {
        self.brand = brand
    }
}
