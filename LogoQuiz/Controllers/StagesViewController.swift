//
//  StagesViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 29/09/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class StagesViewController: MasterViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BrandManager.stages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stageCell", for: indexPath) as! StageCell
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func configure(cell: StageCell, at indexPath: IndexPath) {
        let stageModel = StageViewModel(stage: BrandManager.stages[indexPath.row])
        let isLocked = BrandManager.foundLogos < stageModel.toUnlockStage
        cell.index = indexPath.row
        cell.stageButton.setTitle("Stage \(stageModel.stageNumber)", for: .normal)
        cell.presenter = self
        cell.stageIsLocked = isLocked
        cell.stageButton.alpha = isLocked ? 0.65 : 1.0
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
