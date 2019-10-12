//
//  ViewController.swift
//  Streamline
//
//  Created by Xuezheng Wang on 9/17/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

let ID = "LevelCell"

class LevelsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var gameDelegate: GameLogicDelegate!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    // MARK: - Collection View related
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameDelegate.getNumLevels()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! LevelViewCell
        
        // Set the level number for each cell
        cell.levelLabel.text = String(indexPath.item + 1)
        cell.levelNumber = indexPath.item
        
        // Set if this cell is active
        cell.isActive = ( cell.levelNumber <= gameDelegate.getHighestUnlockedLevel() )
        cell.setNeedsDisplay()
        
        return cell
    }
    

    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is GameViewController
        {
            let vc = segue.destination as? GameViewController
            vc!.currentLevel = (sender as! LevelViewCell).levelNumber
            vc!.gameDelegate = gameDelegate
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "gotoLevel" {
            return (sender as! LevelViewCell).isActive
        }
        
        return true
    }
    
    @IBAction func handlesBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}
