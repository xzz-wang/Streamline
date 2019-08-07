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
    
    // MARK: - Properties
    
    // Main reusing path
    private var path = UIBezierPath()
    private var tileRect = CGRect(x: 30.0, y: 30.0, width: 50.0, height: 50.0)
    
    // Colors that can be accessed by interface builder
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
    
    // The ratio between the gaps and the width/height of each tile
    @IBInspectable var gapRatio: CGFloat = 5.0

    // rols and columns, can be adjusted by interface builder
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
            setNeedsDisplay()
        }
    }
    
    // The 2D array that holds all the TileView
    public var tiles: [[TileView]] = []
    
    // The location of the head of the path
    var headLocation = BoardLocation(row: 0, col: 0)
    
    
    
    // MARK: - Methods
    
    // Two Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTilesArr()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTilesArr()
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
        
        
        // Now layout the tiles, starting with determining the gap, unit length ( 1 gap + 1 width ), and top/buttom margin
        let gap = rect.width / ((gapRatio + 1) * CGFloat(cols) + 1) // Gap between each tile
        let unitLength = (gapRatio + 1) * gap
        var verticalMargin = rect.height - ((gapRatio + 1) * CGFloat(rows) - 1) * gap
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
    }
    
    
    // MARK: - Other Methods
    
    func getTileView(at location: BoardLocation) -> TileView {
        return tiles[location.row][location.column]
    }
    
    func setColor(of location: BoardLocation, to color: UIColor) {
        let theTile = getTileView(at: location)
        theTile.fillColor = color
    }

    
}
