//
//  MasterViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    private let gradientLayer = RadialGradientLayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if gradientLayer.superlayer == nil {
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = self.view.bounds
    }
    
    
}
