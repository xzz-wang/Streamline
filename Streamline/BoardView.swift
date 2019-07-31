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
    
    // Main reusing path
    private var path = UIBezierPath()
    private var tileRect = CGRect(x: 30.0, y: 30.0, width: 50.0, height: 50.0)
    
    // Colors
    @IBInspectable var fillColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 255.0, alpha: 0.3)
    @IBInspectable var tileColor: UIColor = .yellow
    
    // For different rols and cols, can be adjusted by interface builder
    @IBInspectable var rows: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var cols: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var gapRatio: CGFloat = 5.0
    
    // Two Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    // Main Drawing Function
    override func draw(_ rect: CGRect) {
        path = UIBezierPath(roundedRect: rect, cornerRadius: 30.0)
        
        fillColor.setFill()
        
        path.fill()
        
        // Now layout the tiles, starting with some math
        let gap = rect.width / ((gapRatio + 1) * CGFloat(cols) + 1) // Gap between each tile
        let unitLength = (gapRatio + 1) * gap
        var verticalMargin = rect.height - ((gapRatio + 1) * CGFloat(rows) - 1) * gap
        verticalMargin = verticalMargin / 2.0
        
        print(gap)
        print(unitLength)
        print(verticalMargin)
        
        for row in 0..<rows {
            // Setup first of each row
            var tileRect = CGRect(x: gap, y: verticalMargin + CGFloat(row) * unitLength, width: gapRatio * gap, height: gapRatio * gap)
            drawTile(tileRect)
            
            // The rest of the line
            for _ in 1..<cols {
                tileRect = tileRect.offsetBy(dx: unitLength, dy: 0.0)
                drawTile(tileRect)
            }
        }
        
    }
    
    // Helper method to draw each tile
    private func drawTile(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width * 0.2)
        tileColor.setFill()
        path.fill()
    }
    
}
