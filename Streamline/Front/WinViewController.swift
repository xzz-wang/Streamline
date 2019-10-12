//
//  WinViewController.swift
//  Streamline
//
//  Created by Xuezheng Wang on 9/27/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleButton(_ sender: UIButton) {
        // Dismiss all the viewControllers
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
