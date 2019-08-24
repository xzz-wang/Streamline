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
    @IBOutlet private weak var boardView: BoardView!
    @IBOutlet private weak var headView: Head!
    @IBOutlet weak var sampleTrail: Trail!
    
    // MARK: - Customize variables    
    
    // Game logic delegate to back-end
    var gameDelegate: Streamline = Streamline()
    
    // Action Queue
    var actionQueue: [ActionType] = []
    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = true
        sampleTrail.removeFromSuperview()
        headView.removeFromSuperview()
        
        // Setup the head
        boardView.addSubview(boardView.headView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        boardView!.setBoard(with: gameDelegate.getBoard())
    }
    
    // MARK: - User actions
    
    // TODO: Remove for final product. Testing purpose only.
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
                if !boardView.advance(to: tile.location!) {
                    print("Error occurred! Can not move to given location.s")
                }
            }
        }
    }
    
    // An button designed to test stuff.
    // TODO: Remove for final product. Testing purpose only.
    @IBAction func handleTest(_ sender: UIButton) {
        if !boardView.undo() {
            print("Unable to undo!!")
            boardView.alertInvalidMove(forDirection: .right)
        }
    }
    
    // Main User interaction method
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print(sender.direction)
            
            let swipeDirection = sender.direction
            var direction = Direction.up
            
            switch swipeDirection {
                case UISwipeGestureRecognizer.Direction.down:
                    direction = .down
                case UISwipeGestureRecognizer.Direction.up:
                    direction = .up
                case UISwipeGestureRecognizer.Direction.left:
                    direction = .left
                case UISwipeGestureRecognizer.Direction.right:
                    direction = .right
                default:
                    fatalError("Unknown swipe direction!")
            }
            
            // Call the delegate method
            // TODO: Causing the player to never move. Might also need to change handletap
            let reactAction = gameDelegate.move(with: direction)
            
            perform(action: reactAction)
        }
    }
    
    
    // MARK: - Helper methods
    
    // Parse the Action type
    private func perform(action: ActionType) {
        switch action {
        case .advanceTo(let target):
            if( !boardView.advance(to: target) ) {
                fatalError("Not moving to the same row/column! Fatal Error")
            }
        case .invalid(let direction):
            boardView.alertInvalidMove(forDirection: direction)
        case .undo:
            if ( !boardView.undo() ) {
                fatalError("no more actions to be undo!")
            }
        case .win(let target):
            if( !boardView.advance(to: target) ) {
                fatalError("Not moving to the same row/column! Fatal Error")
            }
            win()
            print("We won!")
        }
    }
    
    private func win() {
        // TODO: Fill this in. DO Nothing for now
    }
    
}
