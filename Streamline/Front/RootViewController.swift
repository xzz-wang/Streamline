//
//  RootViewController.swift
//  Streamline
//
//  Created by Xuezheng Wang on 9/27/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    // Game logic delegate to back-end
    var gameDelegate: GameLogicDelegate = TempGameDelegate()

    
    // Use this line when using the actual GameLogicDelegate
    //var gameDelegate: GameLogicDelegate = Streamline()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is LevelsViewController {
            let vc = segue.destination as? LevelsViewController
            vc!.gameDelegate = gameDelegate
        }
    }
    

}
