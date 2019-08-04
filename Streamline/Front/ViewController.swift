//
//  ViewController.swift
//  Streamline
//
//  Created by Xuezheng Wang on 7/26/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - IB Property references
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var rowStepper: UIStepper!
    @IBOutlet weak var colStepper: UIStepper!
    @IBOutlet weak var rowDisplay: UILabel!
    @IBOutlet weak var colDisplay: UILabel!
    
    // MARK: - Customize variables

    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = false
        rowStepper.value = Double(boardView.rows)
        colStepper.value = Double(boardView.cols)
    }
    
    
    // MARK: - User actions
    @IBAction func handleShake(_ sender: UIButton, forEvent event: UIEvent) {
        print("Called!")
        UIView.animate(withDuration: 0.2, animations: {
            self.boardView.center.y -= 100.0
        })
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
            self.boardView.center.y += 100.0
        }, completion: nil)
        print("Here!")
    }
    
    @IBAction func handleStepper(_ sender: UIStepper) {
        boardView.cols = Int(colStepper.value)
        boardView.rows = Int(rowStepper.value)
        
        rowDisplay.text = "Rows: \(boardView.rows)"
        colDisplay.text = "Cols: \(boardView.cols)"
    }
    
}

