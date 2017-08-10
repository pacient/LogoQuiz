//
//  LevelCell.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 08/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class LevelCell: UICollectionViewCell {
    @IBOutlet weak var doneOverlay: UIView!
    @IBOutlet weak var levelLogoImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        doneOverlay.isHidden = true
    }
}
