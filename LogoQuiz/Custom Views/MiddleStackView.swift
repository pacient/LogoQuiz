//
//  MiddleStackView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 01/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MiddleStackView: UIStackView {
    
    func configure(with brandName: String, foundLetter: [[String]]) {
        let wordsInBrand = brandName.split(separator: " ")
        guard wordsInBrand.count > 0 else { return }
        for i in 0...wordsInBrand.count - 1 {
            if let stackView = self.arrangedSubviews[i] as? UIStackView {
                for index in 0...wordsInBrand[i].count - 1 {
                    if let square = stackView.arrangedSubviews[index] as? SquareView {
                        square.isHidden = false
                        if foundLetter[i][index] != " " {
                            square.label.text = foundLetter[i][index]
                            square.isUserInteractionEnabled = false
                            square.alpha = 0.5
                        }
                    }
                }
            }
        }
    }
}
