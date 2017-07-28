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
    
    @IBOutlet weak var middleVerticalStackView: UIStackView!
    @IBOutlet weak var bottomVerticalStackView: UIStackView!
    var brand = "BMW"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMiddleStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureImageView()
        configureNavCircleView()
        configureBottomVerticalStackView()
    }
    
    //This methods shows the correct number of squares under the logo depending on the brand name
    fileprivate func configureMiddleStackView() {
        let wordsInBrand = brand.split(separator: " ")
        guard wordsInBrand.count > 0 else { return }
        for i in 0...wordsInBrand.count - 1 {
            if let stackView = middleVerticalStackView.arrangedSubviews[i] as? UIStackView {
                for index in 0...wordsInBrand[i].count - 1 {
                    stackView.arrangedSubviews[index].isHidden = false
                }
            }
        }
    }
    
    fileprivate func configureImageView() {
        logoImageView.layer.shadowColor = UIColor.black.cgColor
        logoImageView.layer.shadowOpacity = 0.5
        logoImageView.layer.shadowOffset = CGSize(width: -4, height: 7)
        logoImageView.layer.shadowRadius = 3
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
                _ = stack.arrangedSubviews.map {
                    guard let square = $0 as? SquareView else { return }
                    square.label?.text = "\(allLetters.removeFirst())"
                }
            }
        }
    }
    
    fileprivate func getAllLettersToShow() -> [Character]{
        var charArray = [Character]()
        for char in brand { // Get first the letters that are in the actual word
            if char != " " {
                charArray.append(char)
            }
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
