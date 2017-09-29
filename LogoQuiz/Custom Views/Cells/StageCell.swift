//
//  StageCell.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/09/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class StageCell: UITableViewCell {
    @IBOutlet weak var stageButton: YellowButton!
    var index: Int?
    var stageIsLocked: Bool!
    weak var presenter: StagesViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func stageBtnPressed(_ sender: Any) {
        guard let index = index else {return}
        let stageModel = StageViewModel(stage: BrandManager.stages[index])
        if stageIsLocked {
            let alert = UIAlertController(title: "This stage is locked!🔒", message: "To unlock this stage you need \(stageModel.toUnlockStage) solved logos, you've got \(BrandManager.foundLogos).", style: .alert, cancelText: "OK")
            presenter?.present(alert, animated: true, completion: nil)
        } else {
            let playVC = UIStoryboard(name: "PlayScene", bundle: nil).instantiateInitialViewController() as! LevelsCollectionViewController
            playVC.stageModel = stageModel
            presenter?.navigationController?.pushViewController(playVC, animated: true)
        }
    }
}
