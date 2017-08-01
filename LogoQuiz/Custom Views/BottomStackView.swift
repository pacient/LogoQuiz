//
//  BottomStackView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 01/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {
    
    func configure(with letters: [Character]) {
        var letters = letters
        self.arrangedSubviews.forEach { (arrangedView) in
            if let stack = arrangedView as? UIStackView {
                _ = stack.arrangedSubviews.map {
                    guard let square = $0 as? SquareView else { return }
                    square.label?.text = "\(letters.removeFirst())"
                }
            }
        }
    }
}
