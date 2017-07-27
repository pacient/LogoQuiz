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
    @IBOutlet weak var answerStackView: UIStackView!
    
    @IBOutlet weak var bottomVerticalStackView: UIStackView!
    var word = "BMW"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureImageView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavCircleView()
        configureBottomVerticalStackView()
    }
    
    fileprivate func configureStackView() {
        let letters = word.count
        for i in letters...answerStackView.arrangedSubviews.count - 1 {
            answerStackView.arrangedSubviews[i].isHidden = true
        }
    }
    
    fileprivate func configureImageView() {
        logoImageView.layer.cornerRadius = 10
        logoImageView.layer.shadowColor = UIColor.black.cgColor
        logoImageView.layer.shadowOpacity = 0.7
        logoImageView.layer.shadowOffset = CGSize(width: -4, height: 7)
        logoImageView.layer.shadowRadius = 7
        logoImageView.layer.shadowPath = UIBezierPath(rect: logoImageView.bounds).cgPath
    }
    
    fileprivate func configureNavCircleView() {
        let frame = navCircleView.frame
        navCircleView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width)
        navCircleView.layer.cornerRadius = navCircleView.bounds.size.width/2
        navCircleView.layer.borderWidth = 2
        navCircleView.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func configureBottomVerticalStackView() {
        var allLetters = getAllLettersToShow()
        bottomVerticalStackView.arrangedSubviews.forEach { (arrangedView) in
            if let stack = arrangedView as? UIStackView {
               _ = stack.arrangedSubviews.map { ($0 as! SquareView).label.text = "\(allLetters.removeFirst())"
                }
            }
        }
    }
    
    fileprivate func getAllLettersToShow() -> [Character]{
        var charArray = [Character]()
        for char in word { // Get first the letters that are in the actual word
            charArray.append(char)
        }
        for _ in charArray.count..<20 { //Now add random letters to it
            charArray.append(randomLetter())
        }
        charArray.shuffle()
        return charArray
    }
    
    public func randomLetter() -> Character {
        let a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let r = Int(arc4random_uniform(UInt32(a.characters.count)))
        return String(a[a.index(a.startIndex, offsetBy: r)]).characters.first!
    }
    
}
