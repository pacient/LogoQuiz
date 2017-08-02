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
    @IBOutlet weak var middleVerticalStackView: MiddleStackView!
    @IBOutlet weak var bottomVerticalStackView: BottomStackView!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var removeLettersButton: UIButton!
    
    var brandViewModel: BrandViewModel!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let brand = UserManager.brandToFind else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideFindButton), name: Notifications.hideFindButton, object: nil)
        
        brandViewModel = BrandViewModel(brand: brand)
        addTapGestureToSquares()
        middleVerticalStackView.configure(with: brandViewModel.brandName, foundLetter: brandViewModel.foundLetters)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard UserManager.brandToFind != nil else {return}
        bottomVerticalStackView.configure(with: brandViewModel.lettersToShow)
        logoImageView.image = UIImage(named: brandViewModel.imageName)
        if brandViewModel.shouldHideFindButton {
            hideFindButton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.hasRemovedLettersForLevel {
            removeLettersPressed(removeLettersButton)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cashLabel.text = UserManager.cashString
        levelLabel.text = "\(brandViewModel.brandLevel)"
    }
    
    //MARK: Configure Views
    fileprivate func addTapGestureToSquares() {
        middleVerticalStackView.addGestureRecognizerToSubviews(with: #selector(self.removeLetterFromSquare(_:)), target: self)
        bottomVerticalStackView.addGestureRecognizerToSubviews(with: #selector(self.bottomSquareTapped(_:)), target: self)
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
    
    @IBAction func findLettersPressed(_ sender: UIButton) {
        print("find correct letter")
        var letterToShow = brandViewModel.getCorrectLetter()
        guard let key = letterToShow.keys.first else {return}
        let inWord = key.row
        let inSubview = key.section
        let char = letterToShow.values.first!
        let stackView = middleVerticalStackView.arrangedSubviews[inWord] as! UIStackView
        let square = stackView.arrangedSubviews[inSubview] as! SquareView
        if square.isUserInteractionEnabled {
            square.label.text = "\(char)"
            square.isUserInteractionEnabled = false
            square.alpha = 0.5
        }
        checkIfWinner()
    }
    
    @IBAction func removeLettersPressed(_ sender: UIButton) {
        bottomVerticalStackView.arrangedSubviews.flatMap({($0 as? UIStackView)?.arrangedSubviews ?? [$0]}).flatMap({$0 as? SquareView}).forEach { (square) in
            if let char = square.label.text?.characters.first!, !brandViewModel.brandName.contains(char) {
                square.alpha = 0
                square.isUserInteractionEnabled = false
            }
        }
        middleVerticalStackView.arrangedSubviews.flatMap({($0 as? UIStackView)?.arrangedSubviews ?? [$0]}).flatMap({$0 as? SquareView}).forEach { (square) in
            if let char = square.label.text?.characters.first, !brandViewModel.brandName.contains(char) {
                square.label.text = nil
            }
        }
        UserManager.removedLetters()
        sender.isHidden = true
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper Functions
    fileprivate func insertToSquare(letter: String, tag: Int, completion: @escaping () -> Void) {
        for stackview in middleVerticalStackView.arrangedSubviews as! [UIStackView] {
            for square in stackview.arrangedSubviews as! [SquareView] {
                if square.isHidden == false, square.label.text == nil {
                    square.label.text = letter
                    square.tag = tag
                    completion()
                    checkIfWinner()
                    return
                }
            }
        }
    }
    
    @objc fileprivate func hideFindButton() {
        self.findButton.isHidden = true
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
            nextLevel()
        }else {
            //Shake the stack view because WE GOT INCORRECT ANSWER!
            middleVerticalStackView.shake()
        }
    }
    
    fileprivate func nextLevel() {
        UserManager.setValuesForNextLevel()
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
}
