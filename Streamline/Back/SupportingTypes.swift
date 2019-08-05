//
//  SupportingTypes.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/5/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

// The type to specify the location of a tile
// The coordinate system starts at upper-left corner, with index starts with 0.
struct BoardLocation {
    var x: Int
    var y: Int
    
    // Initializers
    init(x: Int, y:Int) {
        self.x = x
        self.y = y
    }
    
    init(row: Int, col:Int) {
        self.x = col
        self.y = row
    }
    
    // Row and column are basicially the same as x and y. Just in case someone got confused.
    var row: Int {
        get { return y }
        set { y = newValue }
    }
    
    var column: Int {
        get { return x }
        set { x = newValue }
    }
    
}


// The enum type that have all the different possible types of a type
// TODO: Check if this is all we need.
enum TileType {
    case normal
    case origin
    case obstacles
    case goal
}

enum Direction {
    case up
    case down
    case left
    case right
}
