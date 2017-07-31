//
//  PlaySceneViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class PlaySceneViewController: MasterViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var middleVerticalStackView: UIStackView!
    @IBOutlet weak var bottomVerticalStackView: UIStackView!
    @IBOutlet weak var cashLabel: UILabel!
    
    var brandViewModel: BrandViewModel!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let brand = UserManager.brandToFind else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        brandViewModel = BrandViewModel(brand: brand)
        levelLabel.text = "\(brandViewModel.brandLevel)"
        addTapGestureToSquares()
        configureMiddleStackView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard UserManager.brandToFind != nil else {return}
        configureImageView()
        configureBottomVerticalStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cashLabel.text = UserManager.cashString
    }
    
    //MARK: Configure Views
    //This methods shows the correct number of squares under the logo depending on the brand name
    fileprivate func configureMiddleStackView() {
        let wordsInBrand = brandViewModel.brandName.split(separator: " ")
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
        logoImageView.image = UIImage(named: brandViewModel.imageName)
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
        navigationController?.popViewController(animated: true)
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
        let wordsNumber = brandViewModel.brandName.split(separator: " ").count
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
        
        if typedWord == brandViewModel.brandName {
            //Proceed to next level
            print("WE HAVE A WINNER!!!!")
            nextLevel()
        }else {
            //Shake the stack view because WE GOT INCORRECT ANSWER!
            print("WE HAVE A LOSER!!!!")
            middleVerticalStackView.shake()
        }
    }
    
    fileprivate func nextLevel() {
        UserDefaults.standard.set(UserManager.levelsCompleted+1, forKey: Constants.levelsCompleted)
        UserDefaults.standard.set(UserManager.cash+5, forKey: Constants.cash)
        guard BrandManager.brands.count > UserManager.levelsCompleted else {
            //Present a screen congratulating the user that they wont the game 🎉
            let alert = UserManager.congratulationsAlert(completion: {
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        //here we are reseting the view controller so all the views go back to their initial state, you don't want to animate it to look more realistic.
        let storyboard = UIStoryboard(name: "PlayScene", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        guard var viewcontrollers = self.navigationController?.viewControllers else {return}
        viewcontrollers.removeLast()
        viewcontrollers.append(vc)
        navigationController?.setViewControllers(viewcontrollers, animated: false)
    }
    
    fileprivate func getAllLettersToShow() -> [Character]{
        var charArray = [Character]()
        for char in brandViewModel.brandName { // Get first the letters that are in the actual word
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
