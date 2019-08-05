//
//  ViewController.swift
//  Streamline
//
//  Created by Xuezheng Wang on 7/26/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import UIKit

typealias BoardLocation = Streamline.BoardLocation

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - IB Property references
    @IBOutlet private weak var boardView: BoardView!
    @IBOutlet private weak var headView: Head!
    
    // MARK: - Customize variables
    var headLocation = BoardLocation(row: 0, col: 0)
    var headSize: CGFloat = 30.0 // width and height of the head
    
    var trails: [Trail] = []
    var trailWidth: CGFloat = 15.0

    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        boardView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        moveHead(to: BoardLocation(row: 0, col: 0))
    }
    
    
    // MARK: - User actions
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
                advance(to: tile.location!)
            }
        }
    }
    
    // This is only for testing
    func setOrigin(at location: BoardLocation) {
        boardView.setColor(of: location, to: boardView.originColor)
        boardView.getTileView(at: location).type = .origin
    }
    
    
    // Move head with trail
    func advance(to location: BoardLocation) {
        // Check if this move is valid
        
        if let thisTrail = createTrail(from: headLocation, to: location) {
            UIView.animate(withDuration: 0.2, animations: {
                self.moveHead(to: location)
                thisTrail.frame = thisTrail.targetRect!
            })
        } else {
            print("Error!")
        }
    }
    
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
            
            if start.column < end.column {
                leftTileFrame = boardView.getTileView(at: start).frame
                rightTileFrame = boardView.getTileView(at: end).frame
            } else if start.column > end.column {
                leftTileFrame = boardView.getTileView(at: end).frame
                rightTileFrame = boardView.getTileView(at: start).frame
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
            let initRect = CGRect(x: x, y: y, width: trailWidth, height: trailWidth)
            
            // Setup the initial trail
            let newTrail = Trail(frame: initRect)
            boardView.addSubview(newTrail)
            newTrail.frame = initRect
            newTrail.targetRect = targetRect
            
            trails.append(newTrail)
            
            
            return newTrail
            
        } else if start.column == end.column {
            // Vertical
            var topTileFrame: CGRect?
            var bottomTileFrame: CGRect?
            
            print("Called!")
            
            if start.row > end.row {
                topTileFrame = boardView.getTileView(at: end).frame
                bottomTileFrame = boardView.getTileView(at: start).frame
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
            let initRect = CGRect(x: x, y: y, width: trailWidth, height: trailWidth)
            let targetRect = CGRect(x: x, y: y, width: trailWidth, height: height)
            
            // Setup the newTrail
            let newTrail = Trail(frame: initRect)
            newTrail.targetRect = targetRect
            
            // Add this trail to subview and the array
            trails.append(newTrail)
            boardView.addSubview(newTrail)
            
            return newTrail
        } else {
            // Not on the same row nor columns
            return nil
        }
    }
    
    
    
    // An button designed to test stuff.
    @IBAction func handleTest(_ sender: UIButton) {
        setOrigin(at: BoardLocation(row: 0, col: 0))
    }
    
}
