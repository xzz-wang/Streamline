//
//  ViewController.swift
//  Streamline
//
//  Created by Xuezheng Wang on 7/26/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

typealias boardLocation = Streamline.boardLocation

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - IB Property references
    @IBOutlet weak var boardView: BoardView!
    
    // MARK: - Customize variables
    var headLocation = boardLocation(row: 0, col: 0)

    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = false
    }
    
    
    // MARK: - User actions
    func moveHeadTo(tile: boardLocation) {
        // TODO: Check if this movement is legal
        
    }
}
