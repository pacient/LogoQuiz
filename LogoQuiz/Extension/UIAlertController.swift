//
//  UIAlertController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 10/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String, message: String, style: UIAlertControllerStyle, cancelText: String) {
        self.init(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        self.addAction(action)
    }
}
