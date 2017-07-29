//
//  YellowButton.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class YellowButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundImage(#imageLiteral(resourceName: "Button"), for: .normal)
    }

}
