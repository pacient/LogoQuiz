//
//  UIStackView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 01/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

extension UIStackView {
    func addGestureRecognizerToSubviews(with selector: Selector, target: Any) {
        for subview in arrangedSubviews {
            if let stackView = subview as? UIStackView {
                stackView.addGestureRecognizerToSubviews(with: selector, target: target)
            }else {
                let tap = UITapGestureRecognizer(target: target, action: selector)
                subview.addGestureRecognizer(tap)
            }
        }
    }
}
