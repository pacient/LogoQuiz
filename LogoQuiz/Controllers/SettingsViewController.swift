//
//  SettingsViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/07/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: MasterViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var blueBar: BlueNavBar!
    @IBOutlet weak var audioButton: UIButton!
    private var token: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserManager.instance.observe(\.isSoundDisabled) { [weak self](manager, _) in
            self?.audioButton.setTitle(manager.isSoundDisabled ? "🔇" : "🔊", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.audioButton.setTitle(UserManager.instance.isSoundDisabled ? "🔇" : "🔊", for: .normal)
        stackview.bounds.origin.x -= self.view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.stackview.bounds.origin.x += self.view.bounds.width
        }, completion: nil)
    }
    
    deinit {
        token = nil
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["logoquizfeedback@gmail.com "])
        mailComposerVC.setSubject("Logo Quiz - Ultimate Game Feedback!")
        return mailComposerVC
    }
    
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Button Actions
    @IBAction func rateGamePressed(_ sender: Any) {
        let url = URL(string: "http://appstore.com/logoquizultimategame")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            let alert = UIAlertController(title: "Ooops", message: "The app failed to open App Store.", style: .alert, cancelText: "OK")
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func contactUsPressed(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func removeAdsPressed(_ sender: Any) {
        guard let product = CashProducts.store.allProducts.first(where: {$0.productIdentifier.contains("AdRemoval")}) else {return}
        let alert = UIAlertController(title: "Remove Ads", message: "Do you want to remove ads from the gameplay for \(product.localizedPrice())?", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "Remove", style: .default) { (_) in
            CashProducts.store.buyProduct(product)
        }
        let restoreAction = UIAlertAction(title: "Restore", style: .default) { (_) in
            CashProducts.store.restorePurchases()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(removeAction)
        alert.addAction(restoreAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buyCashPressed(_ sender: Any) {
        guard CashProducts.store.allProducts.count > 0 else {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please try again later.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: false, completion: nil)
            return
        }
        let vc = UIStoryboard(name: "Products", bundle: nil).instantiateInitialViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func audioButtonPressed(_ sender: Any) {
        UserManager.toggleAudio()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
