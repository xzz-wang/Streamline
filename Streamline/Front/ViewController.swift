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
    var headLocation = BoardLocation(row: 0, col: 0)
    var headSize: CGFloat = 30.0 // TODO: Make this changeable
    
    var trails: [Trail] = []
    var trailWidth: CGFloat = 15.0
    
    private let ANIMATION_DURATION: Double = 0.3
    private let DAMPING_RATIO: CGFloat = 0.7
    private let INVALID_OFFSET: CGFloat = 10.0
    
    // Game logic delegate to back-end
    var gameDelegate: GameLogicDelegate = tempGameDelegate()
    
    // Action Queue
    var actionQueue: [ActionType] = []
    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = true
        sampleTrail.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBoard(with: gameDelegate.getBoard())
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
                if !advance(to: tile.location!) {
                    print("Error occurred! Can not move to given location.s")
                }
            }
        }
    }
    
    // An button designed to test stuff.
    // TODO: Remove for final product. Testing purpose only.
    @IBAction func handleTest(_ sender: UIButton) {
        if !undo() {
            print("Unable to undo!!")
            alertInvalidMove(forDirection: .right)
        }
    }
    
    // Main User interaction method
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print(sender.direction)
            
        }
    }
    
    
    // MARK: - UI Actions: Major useful function to be called
    
    // Reset the entire board with given boardInfo
    func setBoard(with info: BoardInfo) {
        // First, remove stuff
        for trail in trails {
            trail.removeFromSuperview()
        }
        trails = []
        
        // Set the row and col number
        boardView.rows = info.rowNum
        boardView.cols = info.colNum
        
        // Set the color
        for row in boardView.tiles {
            for tile in row {
                tile.fillColor = boardView.tileColor
            }
        }
        
        // Set the tiles' color
        boardView.setColor(of: info.goalLocation, to: boardView.goalColor)
        boardView.setColor(of: info.originLocation, to: boardView.originColor)
        for location in info.obstacleLocations {
            boardView.setColor(of: location, to: boardView.obstacleColor)
        }
        
        // Setup the head
        moveHead(to: info.originLocation)

    }
    
    // Move head with trail
    func advance(to location: BoardLocation) -> Bool{
        // Check if this move is valid
        
        if let thisTrail = createTrail(from: headLocation, to: location) {
            
            // Mark: Advance animation
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0, usingSpringWithDamping: DAMPING_RATIO, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                // Animations
                self.moveHead(to: location)
                thisTrail.frame = thisTrail.targetRect!
            })
            
            return true
        } else {
            return false
        }
    }
    
    // Undo the last movement
    // Return Value: Whether the undo was a success
    func undo() -> Bool {
        
        // If there's another trail, then we can redo it
        if let lastTrail = trails.last {
            let undoLocation = lastTrail.startLocation
            self.trails.removeLast()
            
            // Undo Animation
            UIView.animate(withDuration: ANIMATION_DURATION, delay: 0.0, usingSpringWithDamping: DAMPING_RATIO, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                // Animation actions
                self.moveHead(to: undoLocation!)
                lastTrail.frame = lastTrail.initRect!
                lastTrail.alpha = 0.0
            }, completion: { success in
                // Completion code
                if success {
                    lastTrail.removeFromSuperview()
                }
            })
            return true
        }
        
        return false
    }
    
    func alertInvalidMove(forDirection direction: Direction) {
        let transform = direction.getTransform(withOffset: INVALID_OFFSET)
        
        UIView.animate(withDuration: ANIMATION_DURATION / 2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.headView.transform = transform
        }, completion: nil)

        UIView.animate(withDuration: ANIMATION_DURATION / 2, delay: ANIMATION_DURATION / 2, options: .curveEaseInOut, animations: {
            self.headView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }, completion: nil)

        
    }

    // MARK: - Helper methods
    
    
    // move the headView to the given boardLocation. Everything is taken care of.
    private func moveHead(to location: BoardLocation){
        // Just move the head
        headLocation = location
        
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
    
    // Create a trail. true means success, false means the given params are illegal
    private func createTrail(from start: BoardLocation, to end: BoardLocation) -> Trail? {
        // Check if the trail is horizontal or vertical
        if start.row == end.row {
            // Horizontal
            var leftTileFrame: CGRect?
            var rightTileFrame: CGRect?
            var willReverseAnimate = false
            
            if start.column < end.column {
                leftTileFrame = boardView.getTileView(at: start).frame
                rightTileFrame = boardView.getTileView(at: end).frame
            } else if start.column > end.column {
                leftTileFrame = boardView.getTileView(at: end).frame
                rightTileFrame = boardView.getTileView(at: start).frame
                
                willReverseAnimate = true
            } else {
                // start and end are the same tile! no way!
                return nil
            }
            
            // Math time!
            let x: CGFloat = leftTileFrame!.minX + leftTileFrame!.width / 2 - trailWidth / 2
            let y: CGFloat = leftTileFrame!.minY + leftTileFrame!.width / 2 - trailWidth / 2
            let width: CGFloat = rightTileFrame!.maxX - rightTileFrame!.width / 2 + trailWidth / 2 - x
            
            // will animate from initRect to targetRect
            let targetRect = CGRect(x: x, y: y, width: width, height: trailWidth)
            var initRect = CGRect(x: x, y: y, width: trailWidth, height: trailWidth)
            
            if willReverseAnimate {
                initRect = CGRect(x: width + x - trailWidth, y: y, width: trailWidth, height: trailWidth)
            }
            
            // Setup the new trail
            let newTrail = Trail(frame: initRect)
            newTrail.initRect = initRect
            newTrail.targetRect = targetRect
            newTrail.startLocation = start
            newTrail.endLocation = end
            
            trails.append(newTrail)
            boardView.addSubview(newTrail)

            
            return newTrail
            
        } else if start.column == end.column {
            // Vertical
            var topTileFrame: CGRect?
            var bottomTileFrame: CGRect?
            
            var willReverseAnimate = false
            
            if start.row > end.row {
                topTileFrame = boardView.getTileView(at: end).frame
                bottomTileFrame = boardView.getTileView(at: start).frame
                
                willReverseAnimate = true
            } else if start.row < end.row {
                topTileFrame = boardView.getTileView(at: start).frame
                bottomTileFrame = boardView.getTileView(at: end).frame
            } else {
                // start and end are the same tile! no way!
                return nil
            }
            
            // Math time!
            let x: CGFloat = topTileFrame!.minX + topTileFrame!.width / 2 - trailWidth / 2
            let y: CGFloat = topTileFrame!.minY + topTileFrame!.height / 2 - trailWidth / 2
            let height: CGFloat = bottomTileFrame!.maxY - bottomTileFrame!.height / 2 + trailWidth / 2 - y
            
            // calculate initRect and targetRect
            var initRect = CGRect(x: x, y: y, width: trailWidth, height: trailWidth)
            let targetRect = CGRect(x: x, y: y, width: trailWidth, height: height)
            
            if willReverseAnimate {
                initRect = CGRect(x: x, y: y + height - trailWidth, width: trailWidth, height: trailWidth)
            }
            
            // Setup the newTrail
            let newTrail = Trail(frame: initRect)
            newTrail.targetRect = targetRect
            newTrail.initRect = initRect
            newTrail.startLocation = start
            newTrail.endLocation = end
            
            // Add this trail to subview and the array
            trails.append(newTrail)
            boardView.addSubview(newTrail)
            
            return newTrail
        } else {
            // Not on the same row nor columns
            return nil
        }
    }
    
    
    // Parse the Action type
    private func perform(action: ActionType) {
        switch action {
        case .advanceTo(let target):
            if( !advance(to: target) ) {
                fatalError("Not moving to the same row/column! Fatal Error")
            }
        case .invalid(let direction):
            alertInvalidMove(forDirection: direction)
        case .undo:
            if ( !undo() ) {
                fatalError("no more actions to be undo!")
            }
        case .win:
            //TODO: Get win action
            print("We won!")
        }
    }
    
}
