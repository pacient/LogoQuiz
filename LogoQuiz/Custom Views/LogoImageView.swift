//
//  LogoImageView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 01/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class LogoImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -4, height: 7)
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
