//
//  PlaySceneViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class PlaySceneViewController: MasterViewController {
    @IBOutlet weak var navCircleView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var middleVerticalStackView: UIStackView!
    @IBOutlet weak var bottomVerticalStackView: UIStackView!
    var brand = "SEVEN ELEVEN"
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSquares()
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
    
    //MARK: Configure Views
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
    
    fileprivate func addTapGestureToSquares() {
        _ = middleVerticalStackView.arrangedSubviews.map { ($0 as? UIStackView)?.arrangedSubviews.map{
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeLetterFromSquare(_:)))
                $0.addGestureRecognizer(tap)
            }
        }
        _ = bottomVerticalStackView.arrangedSubviews.map { ($0 as? UIStackView)?.arrangedSubviews.map{
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.bottomSquareTapped(_:)))
                $0.addGestureRecognizer(tap)
            }
        }
    }
    
    //MARK: Actions
    @objc func bottomSquareTapped(_ sender: UITapGestureRecognizer) {
        guard let squareView = sender.view as? SquareView else { return }
        guard let letter = squareView.label.text, squareView.isUserInteractionEnabled else { return }
        //add the letter to the next available square in the middle stack
        insertToSquare(letter: letter, tag: squareView.tag) {
            //disable the pressed view
            squareView.isUserInteractionEnabled = false
            squareView.alpha = 0.5
        }
    }
    
    @objc func removeLetterFromSquare(_ sender: UITapGestureRecognizer) {
        guard let squareView = sender.view as? SquareView else { return }
        guard squareView.label.text != nil else { return }
        squareView.label.text = nil
        let stackIndex = squareView.tag >= 10 ? 1 : 0
        let bottomSquare = (bottomVerticalStackView.arrangedSubviews[stackIndex] as? UIStackView)?.arrangedSubviews.filter{$0.tag == squareView.tag}.first as! SquareView
        bottomSquare.isUserInteractionEnabled = true
        bottomSquare.alpha = 1
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        //go back to main menu
    }
    
    //MARK: Helper Functions
    fileprivate func insertToSquare(letter: String, tag: Int, completion: @escaping () -> Void) {
        loop: for stackview in middleVerticalStackView.arrangedSubviews as! [UIStackView] {
            for square in stackview.arrangedSubviews as! [SquareView] {
                if square.isHidden == false, square.label.text == nil {
                    square.label.text = letter
                    square.tag = tag
                    completion()
                    checkIfWinner()
                    break loop
                }
            }
        }
    }
    
    fileprivate func checkIfWinner() {
        let wordsNumber = brand.split(separator: " ").count
        var typedWord = ""
        let firstStack = middleVerticalStackView.arrangedSubviews[0] as! UIStackView
        let visibleSquares = firstStack.arrangedSubviews.filter{ $0.isHidden == false} as! [SquareView]
        for square in visibleSquares {
            guard let letter = square.label.text else { return }
            typedWord += letter
        }
        if wordsNumber > 1 {
            typedWord += " "
            let secondStack = middleVerticalStackView.arrangedSubviews[1] as! UIStackView
            let visibleSecondSquares = secondStack.arrangedSubviews.filter{ $0.isHidden == false} as! [SquareView]
            for square in visibleSecondSquares {
                guard let letter = square.label.text else { return }
                typedWord += letter
            }
        }
        
        if typedWord == brand {
            //Proceed to next level
            print("WE HAVE A WINNER!!!!")
        }else {
            //Shake the stack view because WE GOT INCORRECT ANSWER!
            print("WE HAVE A LOSER!!!!")
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
    
    fileprivate func randomLetter() -> Character {
        let a = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let r = Int(arc4random_uniform(UInt32(a.characters.count)))
        return String(a[a.index(a.startIndex, offsetBy: r)]).characters.first!
    }
    
}
