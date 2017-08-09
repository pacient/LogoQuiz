//
//  PlaySceneViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 27/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class PlaySceneViewController: MasterViewController, GameHintDelegate {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var middleVerticalStackView: MiddleStackView!
    @IBOutlet weak var bottomVerticalStackView: BottomStackView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var removeLettersButton: UIButton!
    @IBOutlet weak var blueBar: BlueNavBar!
    
    var brandViewModel: BrandViewModel!
    var lettersToShow: [Character]!
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(hideFindButton), name: Notifications.hideFindButton, object: nil)
        UserManager.delegate = self
        lettersToShow = brandViewModel.lettersToShow
        addTapGestureToSquares()
        if brandViewModel.isDone {
            let allCorrectLetters = brandViewModel.brandName.components(separatedBy: " ").map({$0.characters.map{String($0)}})
            middleVerticalStackView.configure(with: brandViewModel.brandName, foundLetter: allCorrectLetters)
            removeLettersButton.isHidden = true
            hideFindButton()
        }else {
            middleVerticalStackView.configure(with: brandViewModel.brandName, foundLetter: brandViewModel.foundLetters)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomVerticalStackView.configure(with: lettersToShow)
        logoImageView.image = UIImage(named: brandViewModel.imageName)
        if brandViewModel.shouldHideFindButton  {
            hideFindButton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if  brandViewModel.gameState.hasRemovedLetters { //UserManager.hasRemovedLettersForLevel {
            removeLetters()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.bottomVerticalStackView.alpha = 1
            self.middleVerticalStackView.alpha = 1
            self.logoImageView.alpha = 1
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        levelLabel.text = "\(brandViewModel.brandLevel)"
    }
    
    //MARK: Configure Views
    fileprivate func addTapGestureToSquares() {
        middleVerticalStackView.addGestureRecognizerToSubviews(with: #selector(self.removeLetterFromSquare(_:)), target: self)
        bottomVerticalStackView.addGestureRecognizerToSubviews(with: #selector(self.bottomSquareTapped(_:)), target: self)
    }
    
    fileprivate func addCelebrationView(completion: @escaping ()->Void) {
        let celebrationView = CelebrationView(frame: view.bounds)
        view.addSubview(celebrationView)
        celebrationView.startConfetti()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            completion()
        }
    }
    
    //MARK: Actions
    @objc func bottomSquareTapped(_ sender: UITapGestureRecognizer) {
        guard let squareView = sender.view as? SquareView else { return }
        guard let letter = squareView.label.text else { return }
        
        if squareView.alpha == 1  {
            //add the letter to the next available square in the middle stack
            insertToSquare(letter: letter, tag: squareView.tag) {
                //disable the pressed view
                squareView.alpha = 0.5
            }
        }else {
            //remove the letter from the middle view
            removeFromSquare(with: squareView.tag)
        }
        
    }
    
    @objc func removeLetterFromSquare(_ sender: UITapGestureRecognizer) {
        guard let squareView = sender.view as? SquareView else { return }
        guard squareView.label.text != nil else { return }
        squareView.label.text = nil
        let stackIndex = squareView.tag >= 10 ? 1 : 0
        let bottomSquare = (bottomVerticalStackView.arrangedSubviews[stackIndex] as? UIStackView)?.arrangedSubviews.filter{$0.tag == squareView.tag}.first as! SquareView
        bottomSquare.alpha = 1
    }
    
    @IBAction func findLettersPressed(_ sender: UIButton) {
        let alert = UserManager.giveLetterHintAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeLettersPressed(_ sender: UIButton) {
        let alert = UserManager.removeLettersHintAlert()
        self.present(alert, animated: true, completion: nil)
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
    
    fileprivate func removeFromSquare(with tag: Int) {
        let square = (middleVerticalStackView.arrangedSubviews[0] as? UIStackView)?.arrangedSubviews.first(where: {$0.tag == tag}) as? SquareView ??
        /*else check in the second stackView*/(middleVerticalStackView.arrangedSubviews[1] as? UIStackView)?.arrangedSubviews.first(where: {$0.tag == tag}) as? SquareView
        guard square != nil else {return}
        square?.label.text = nil
        let stackIndex = square!.tag >= 10 ? 1 : 0
        let bottomSquare = (bottomVerticalStackView.arrangedSubviews[stackIndex] as? UIStackView)?.arrangedSubviews.filter{$0.tag == square?.tag}.first as! SquareView
        bottomSquare.alpha = 1
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
            UserManager.setValuesForNextLevel()
            brandViewModel.isDone = true
            addCelebrationView {
                self.nextLevel()
            }
        }else {
            //Shake the stack view because WE GOT INCORRECT ANSWER!
            middleVerticalStackView.shake()
        }
    }
    
    fileprivate func nextLevel() {
        guard var viewcontrollers = self.navigationController?.viewControllers else {return}
        viewcontrollers.removeLast()//remove the play scene
        navigationController?.setViewControllers(viewcontrollers, animated: true)
    }
    
    //MARK: Delegates
    func removeLetters() {
        DispatchQueue.main.async {
            self.bottomVerticalStackView.arrangedSubviews.flatMap({($0 as? UIStackView)?.arrangedSubviews ?? [$0]}).flatMap({$0 as? SquareView}).forEach { (square) in
                if let char = square.label.text?.characters.first!, !self.brandViewModel.brandName.contains(char) {
                    square.alpha = 0
                    square.isUserInteractionEnabled = false
                }
            }
            self.middleVerticalStackView.arrangedSubviews.flatMap({($0 as? UIStackView)?.arrangedSubviews ?? [$0]}).flatMap({$0 as? SquareView}).forEach { (square) in
                if let char = square.label.text?.characters.first, !self.brandViewModel.brandName.contains(char) {
                    square.label.text = nil
                }
            }
            self.brandViewModel.hasRemovedLetters = true
            self.removeLettersButton.isHidden = true
        }
    }
    
    func giveCorrectLetter() {
        DispatchQueue.main.async {
            var letterToShow = self.brandViewModel.getCorrectLetter()
            guard let key = letterToShow.keys.first else {return}
            let inWord = key.row
            let inSubview = key.section
            let char = letterToShow.values.first!
            let stackView = self.middleVerticalStackView.arrangedSubviews[inWord] as! UIStackView
            let square = stackView.arrangedSubviews[inSubview] as! SquareView
            if square.isUserInteractionEnabled {
                square.label.text = "\(char)"
                square.isUserInteractionEnabled = false
                square.alpha = 0.5
            }
            self.checkIfWinner()
        }
    }
}
