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
    @IBOutlet weak var headView: Head!
    
    // MARK: - Customize variables
    var headLocation = boardLocation(row: 0, col: 0)
    var headSize: CGFloat = 30.0 // width and height of the head
    var trails: [Trail] = []

    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moveHead(to: boardLocation(row: 0, col: 0))
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
                UIView.animate(withDuration: 0.2, animations: {
                    self.moveHead(to: tile.location!)
                })
            }
        }
    }
    
    // This is only for testing
    func setOrigin(at location: boardLocation) {
        boardView.setColor(of: location, to: boardView.originColor)
        boardView.getTileView(at: location).type = .origin
    }
    
    func moveHead(to location: boardLocation){
        // Just move the head
        
        // A bit of math first
        let theTileFrame = boardView.getTileView(at: location).frame
        let x = theTileFrame.minX + theTileFrame.width / 2 - headSize / 2
        let y = theTileFrame.minY + theTileFrame.height / 2 - headSize / 2
        
        // Move the head
        let rect = CGRect(x: x, y: y, width: headSize, height: headSize)
        headView.frame = rect
        
        // Bring it to the front
        boardView.bringSubviewToFront(headView)
        boardView.setNeedsDisplay()
    }
    
    
    
    // An button designed to test stuff.
    @IBAction func handleTest(_ sender: UIButton) {
        setOrigin(at: boardLocation(row: 0, col: 0))
    }
    
}
