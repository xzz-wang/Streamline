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
        
        boardView.isUserInteractionEnabled = true
        
    }
    
    
    // MARK: - User actions
    func moveHeadTo(tile: boardLocation) {
        // TODO: Check if this movement is legal
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            //Get the tile that was tapped on
            var tappedTile: TileView? = nil
            
            let tappedLocation = sender.location(in: boardView)
            outerLoop: for row in boardView.tiles {
                for tile in row {
                    if tile.frame.contains(tappedLocation) {
                        tappedTile = tile
                        break outerLoop
                    }
                }
            }
            
            if let tile = tappedTile {
                if tile.type == .normal{
                    tile.type = .obstacles
                    tile.fillColor = boardView.obstacleColor
                } else if tile.type == .obstacles {
                    tile.type = .normal
                    tile.fillColor = boardView.tileColor
                }
                
                tile.setNeedsDisplay()
            }
        }
    }
    
    func setOrigin(at location: boardLocation) {
        boardView.setColor(of: location, to: boardView.originColor)
        boardView.getTileView(at: location).type = .origin
    }
    
    func moveHead(to location: boardLocation){
        
    }
    
    
    
    // An button designed to test stuff.
    @IBAction func handleTest(_ sender: UIButton) {
        setOrigin(at: boardLocation(row: 0, col: 0))
    }
    
}
