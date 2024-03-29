//
//  SquareView.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class SquareView: UIView {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addCharLabel()
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        let fontSize = (bounds.width/2) + 5
        label.font = UIFont.eurostile(with: fontSize)
        configure()
    }
    
    fileprivate func addCharLabel() {
        //add the label that will contain the letter for each box
        label = UILabel()
        label.textAlignment = .center
        
        addSubview(label)
    }
    
    fileprivate func configure() {
        //add shadow and rounded corners
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: -1, height: 3)
        layer.shadowRadius = 3
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
