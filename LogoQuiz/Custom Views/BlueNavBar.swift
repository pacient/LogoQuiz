//
//  BlueNavBar.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 03/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class BlueNavBar: UIView {
    var cashLabel: CashLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func configure() {
        if cashLabel == nil {
            cashLabel = CashLabel()
            cashLabel.translatesAutoresizingMaskIntoConstraints = false
            cashLabel.font = UIFont.eurostile(with: 20)
            cashLabel.textColor = .white
            addSubview(cashLabel)
            
            let trailing = NSLayoutConstraint(item: cashLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8)
            let bottom = NSLayoutConstraint(item: cashLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -8)
            
            addConstraints([trailing,bottom])
        }
        backgroundColor = .darkBlue
    }
}
