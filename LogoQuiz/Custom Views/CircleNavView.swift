//
//  CircleNavView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class CircleNavView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func configure() {
        self.layer.cornerRadius = self.bounds.size.width/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}
