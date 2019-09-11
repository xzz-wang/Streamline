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
    // var gameDelegate: GameLogicDelegate = TempGameDelegate()

    
    // Use this line when using the actual GameLogicDelegate
    var gameDelegate: GameLogicDelegate = Streamline()
    
    
    // Provide feedBack
    var feedbackGenerator: UIImpactFeedbackGenerator? = nil

    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = true
        sampleTrail.removeFromSuperview()
        sampleTrail = nil
        headView.removeFromSuperview()
        headView = nil
        
        // Setup the head
        boardView.addSubview(boardView.headView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        boardView!.setBoard(with: gameDelegate.getNextLevelBoard())
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
                        tappedTile = tile // TODO: Make it move all the way to the end, remove possibility of staying in the middle
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
        
        // TODO: Fix crash & not cancelling the trail when dragging undo
        
        if sender.state == .ended {
            
            feedbackGenerator = UIImpactFeedbackGenerator()
            feedbackGenerator?.prepare()
            
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
            let reactAction = gameDelegate.move(with: direction)
            
            perform(action: reactAction)
        }
    }
    
    
    // MARK: - Helper methods
    
    // Parse the Action type
    private func perform(action: ActionType) {
        // Provide force feedback
        print("Action: \(action)")
        
        // TODO: Fix not calling win
        
        switch action {
        case .advanceTo(let target):
            if( !boardView.advance(to: target) ) {
                fatalError("Not moving to the same row/column! Fatal Error")
            }
        case .invalid(let direction):
            boardView.alertInvalidMove(forDirection: direction)
            feedbackGenerator?.impactOccurred()
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
        
        feedbackGenerator = nil
    }
    
    // Called when a win is achieved. Get a new level and create a transition.
    private func win() {
        // Get the offset between boardView and self.view
        let offsetX = boardView.frame.minX
        let offsetY = boardView.frame.minY
        
        // Create a fake head that will animate to cover the entire view
        let fakeHead = Head(frame: boardView.headView.frame)
        fakeHead.transform = CGAffineTransform(translationX: offsetX, y: offsetY)
        self.view.addSubview(fakeHead)
        
        // Come up with a final frame for the animation
        let zoomSize = UIScreen.main.bounds.height * 2
        let xLoc = fakeHead.center.x - zoomSize / 2
        let yLoc = fakeHead.center.y - zoomSize / 2
        let targetFrame = CGRect(x: xLoc , y: yLoc, width: zoomSize, height: zoomSize)
        
        // Perform animation
        UIView.animate(withDuration: 0.4, delay: boardView.ANIMATION_DURATION, options: .curveEaseIn, animations: {
            
            fakeHead.frame = targetFrame
            
        }, completion: { _ in
            // Setup the next board
            self.boardView.setBoard(with: self.gameDelegate.getNextLevelBoard())
            
            // Calculate the target frame
            let targetFrame = self.boardView.headView.frame.applying(CGAffineTransform(translationX: offsetX, y: offsetY))
            
            // Animate back into the next level
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                fakeHead.frame = targetFrame
            }, completion: {_ in
                fakeHead.removeFromSuperview()
            })
            
        })
    }
    
}
