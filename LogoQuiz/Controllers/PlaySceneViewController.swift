//
//  PlaySceneViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class PlaySceneViewController: UIViewController {
    @IBOutlet weak var navCircleView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavCircleView()
        addShadow(to: logoImageView)
    }
    
    fileprivate func configureNavCircleView() {
        let frame = navCircleView.frame
        navCircleView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width)
        navCircleView.layer.cornerRadius = navCircleView.bounds.size.width/2
        navCircleView.layer.borderWidth = 2
        navCircleView.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func addShadow(to: UIView) {
        to.layer.shadowColor = UIColor.black.cgColor
        to.layer.shadowOpacity = 0.7
        to.layer.shadowOffset = CGSize(width: -4, height: 7)
        to.layer.shadowRadius = 7
        to.layer.shouldRasterize = true
    }
}
