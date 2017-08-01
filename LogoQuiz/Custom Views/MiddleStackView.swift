//
//  MiddleStackView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 01/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MiddleStackView: UIStackView {

    func configureWith(brandName name: String) {
        let wordsInBrand = name.split(separator: " ")
        guard wordsInBrand.count > 0 else { return }
        for i in 0...wordsInBrand.count - 1 {
            if let stackView = self.arrangedSubviews[i] as? UIStackView {
                for index in 0...wordsInBrand[i].count - 1 {
                    stackView.arrangedSubviews[index].isHidden = false
                }
            }
        }
    }

}
