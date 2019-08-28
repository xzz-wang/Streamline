//
//  BoardView.swift
//  Streamline
//
//  Created by Xuezheng Wang on 7/26/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BoardView: UIView {
    
    let ANIMATION_DURATION: Double = 0.3
    let DAMPING_RATIO: CGFloat = 0.7
    let INVALID_OFFSET: CGFloat = 10.0
    
    // MARK: - Properties
    // MARK: Main reusing path
    private var path = UIBezierPath()
    private var tileRect = CGRect(x: 30.0, y: 30.0, width: 50.0, height: 50.0)
    
    // MARK: Colors
    @IBInspectable var fillColor: UIColor = .white
    @IBInspectable var tileColor: UIColor = .red {
        didSet {
            for row in tiles {
                for tile in row {
                    if tile.type == .blank { tile.fillColor =  self.tileColor}
                }
            }
        }
    }
    @IBInspectable var originColor: UIColor = .blue
    @IBInspectable var obstacleColor: UIColor = .darkGray
    @IBInspectable var goalColor: UIColor = .purple

    // The ratio between the gaps and the width/height of each tile
    @IBInspectable var gapRatio: CGFloat = 5.0

    // MARK: rols and columns, can be adjusted by interface builder
    // Whenever these two value changes, the didSets update change the size of tiles array,
    //  and add/remove subview accordingly
    @IBInspectable var rows: Int = 5 {
        didSet { // code inside didSet is called when the variable did finish changing
            // If new rows need to be added, perform addition
            if rows > oldValue {
                for row in oldValue..<rows {
                    var newRow: [TileView] = []
                    for col in 0..<cols { // Create a new row
                        let newTile = TileView()
                        newTile.location = BoardLocation(row: row, col: col)
                        newRow.append(newTile)
                        self.addSubview(newTile)
                    }
                    tiles.append(newRow)
                }
                
            } else if rows < oldValue { // If rows needs to be removed
                for _ in rows..<oldValue {
                    for colTile in tiles.last! {
                        colTile.removeFromSuperview()
                    }
                    tiles.removeLast()
                }
            }
            
            // Let the system redraw this view
            //updateTileFrames()
            setNeedsDisplay()
        }
        
    }
    
    @IBInspectable var cols: Int = 5 {
        didSet {
            if cols > oldValue { // If new col needs to be added
                for row in 0..<rows {
                    for col in oldValue..<cols {
                        let newTile = TileView()
                        newTile.location = BoardLocation(row: row, col: col)
                        tiles[row].append(newTile)
                        self.addSubview(newTile)
                    }
                }
            } else if cols < oldValue { // If cols need to be deleted
                for i in 0..<rows {
                    for _ in cols..<oldValue {
                        tiles[i].last!.removeFromSuperview()
                        tiles[i].removeLast()
                    }
                }
            }
            //updateTileFrames()
            setNeedsDisplay()
        }
    }
    
    // MARK: Subviews and layout info
    // The 2D array that holds all the TileView
    public var tiles: [[TileView]] = []
    
    // The location of the head of the path
    var headView: Head!
    var headLocation = BoardLocation(row: 0, col: 0) // TODO: Use player current location
    private let HEAD_SIZE_RATIO: CGFloat = 0.65
    
    // Trails
    private var trails: [Trail] = []
    private var trailWidth: CGFloat = 15.0

    
    
    
    // MARK: - Methods
    
    // Two Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.isOpaque = false
        initTilesArr()
        
        headView = Head(frame: super.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTilesArr()
        self.layer.isOpaque = false
        
        headView = Head(frame: frame)
    }
    
    // Called in the initializers
    // Description: create TileViews, put them in the tiles array, and add subViews to self
    private func initTilesArr() {
        
        for row in 0..<rows {
            var aRow: [TileView] = []
            for col in 0..<cols {
                let newTile = TileView()
                newTile.location = BoardLocation(row: row, col: col)
                aRow.append(newTile)
                self.addSubview(newTile)
            }
            tiles.append(aRow)
        }
    }
    
    
    // MARK: - Main Drawing Function
    // This will be called everytime the view needs to be redrawn
    override func draw(_ rect: CGRect) {
        
        // Background rounded rect drawing code. 
        path = UIBezierPath(roundedRect: rect, cornerRadius: 30.0)
        fillColor.setFill()
        path.fill()
        
        updateSubviews()
    }
    
    
    
    // MARK: - Methods called by ViewController
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
    
    // Reset the entire board with given boardInfo
    func setBoard(with info: BoardInfo) {
        // First, remove stuff
        for trail in trails {
            trail.removeFromSuperview()
        }
        trails = []
        
        // Set the row and col number
        rows = info.rowNum
        cols = info.colNum
        
        // Set the color
        for row in tiles {
            for tile in row {
                tile.fillColor = tileColor
            }
        }
        
        // Set the tiles' color
        setColor(of: info.goalLocation, to: goalColor)
        setColor(of: info.originLocation, to: originColor)
        for location in info.obstacleLocations {
            setColor(of: location, to: obstacleColor)
        }
        
        // Setup the head
        //headLocation = info.originLocation
        moveHead(to: info.originLocation)
        
        setNeedsDisplay()
        
    }
    
    
    // MARK: - Helper Methods
    
    func getTileView(at location: BoardLocation) -> TileView {
        return tiles[location.row][location.column]
    }
    
    func setColor(of location: BoardLocation, to color: UIColor) {
        let theTile = getTileView(at: location)
        theTile.fillColor = color
    }
    
    private func updateSubviews () {
        
        // Now layout the tiles, starting with determining the gap, unit length ( 1 gap + 1 width ), and top/buttom margin
        let gap = self.frame.width / ((gapRatio + 1) * CGFloat(cols) + 1) // Gap between each tile
        let unitLength = (gapRatio + 1) * gap
        var verticalMargin = self.frame.height - ((gapRatio + 1) * CGFloat(rows) - 1) * gap
        verticalMargin = verticalMargin / 2.0
        
        // Adjust the position of each tile according to row and cols
        for row in 0..<self.rows {
            // Setup first of each row
            var tileRect = CGRect(x: gap, y: verticalMargin + CGFloat(row) * unitLength, width: self.gapRatio * gap, height: self.gapRatio * gap)
            self.tiles[row][0].frame = tileRect
            
            // The rest of the line
            for col in 1..<self.cols {
                tileRect = tileRect.offsetBy(dx: unitLength, dy: 0.0)
                self.tiles[row][col].frame = tileRect
            }
        }
        
        // Put the head to the right location.
        moveHead(to: headLocation)
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
                leftTileFrame = getTileView(at: start).frame
                rightTileFrame = getTileView(at: end).frame
            } else if start.column > end.column {
                leftTileFrame = getTileView(at: end).frame
                rightTileFrame = getTileView(at: start).frame
                
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
            self.addSubview(newTrail)
            
            
            return newTrail
            
        } else if start.column == end.column {
            // Vertical
            var topTileFrame: CGRect?
            var bottomTileFrame: CGRect?
            
            var willReverseAnimate = false
            
            if start.row > end.row {
                topTileFrame = getTileView(at: end).frame
                bottomTileFrame = getTileView(at: start).frame
                
                willReverseAnimate = true
            } else if start.row < end.row {
                topTileFrame = getTileView(at: start).frame
                bottomTileFrame = getTileView(at: end).frame
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
            self.addSubview(newTrail)
            
            return newTrail
        } else {
            // Not on the same row nor columns
            return nil
        }
    }
    
    
    // move the headView to the given boardLocation. Everything is taken care of.
    private func moveHead(to location: BoardLocation){
        // Just move the head
        headLocation = location
        
        // A bit of math first
        let theTileFrame = getTileView(at: location).frame
        let headSize = theTileFrame.width * HEAD_SIZE_RATIO
        let x = theTileFrame.minX + theTileFrame.width / 2 - headSize / 2
        let y = theTileFrame.minY + theTileFrame.height / 2 - headSize / 2
        
        // Move the head
        let rect = CGRect(x: x, y: y, width: headSize, height: headSize)
        headView.frame = rect
        
        // Bring it to the front
        self.bringSubviewToFront(headView)
        self.setNeedsDisplay()
    }
    


}
