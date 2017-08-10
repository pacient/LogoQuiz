//
//  LevelsCollectionViewController.swift
//  LogoQuiz
//
//  Created by Vasil Nunev on 08/08/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class LevelsCollectionViewController: MasterViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func configure(cell: LevelCell, with brandModel: BrandViewModel) {
        cell.levelLogoImageView.image = UIImage(named: brandModel.imageName)
        if brandModel.isDone {
            cell.doneOverlay.isHidden = false
        }
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BrandManager.brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as! LevelCell
        configure(cell: cell, with: BrandViewModel(brand: BrandManager.brands[indexPath.row]))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brandViewModel = BrandViewModel(brand: BrandManager.brands[indexPath.row])
        let vc = UIStoryboard(name: "PlayScene", bundle: nil).instantiateViewController(withIdentifier: "playScene") as! PlaySceneViewController
        vc.brandViewModel = brandViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width*0.33-2, height: 100)
    }
}
