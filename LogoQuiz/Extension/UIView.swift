//
//  UIView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 31/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import AVFoundation

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.3
        animation.values = [-10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func enlarge() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 1.0
        animation.values = [1.0, 1.1, 1.2, 1.3, 1.2, 1.1, 1.0]
        layer.add(animation, forKey: kCATransitionPush)
    }
    
    func shrink() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 1.0
        animation.values = [1.0, 0.9, 0.8, 0.7, 0.8, 0.9, 1.0]
        layer.add(animation, forKey: kCATransitionPush)
    }
}
