//
//  SupportingTypes.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/5/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation
import UIKit

// The type to specify the location of a tile
// The coordinate system starts at upper-left corner, with index starts with 0.
struct BoardLocation: Equatable {
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
    
    static func == (this: BoardLocation, that: BoardLocation) -> Bool {
        return this.x == that.x && this.y == that.y
    }
    
//    static postfix func == (other: BoardLocation) -> Bool { // prefix or postfix?
//        return self.row == other.row && self.column == other.column
//    }
    // Note: 这个method都static了就应该不能access self了吧
    
}


// The enum type that have all the different possible types of a type
enum TileType {
    case blank
    case origin
    case obstacle
    case goal
    case trail
}

enum Direction: Int {
    case up = 1
    case down = 3
    case left = 2
    case right = 0
    
    func getTransform(withOffset offset: CGFloat) -> CGAffineTransform {
        switch self {
        case .up:
            return CGAffineTransform(translationX: 0.0, y: -offset)
        case .down:
            return CGAffineTransform(translationX: 0.0, y: offset)
        case .left:
            return CGAffineTransform(translationX: -offset, y: 0.0)
        case .right:
            return CGAffineTransform(translationX: offset, y: 0.0)
        }
    }
}

// MARK: - Front-back interaction

// Used for initializing the board
struct BoardInfo {
    // Number of rows and cols
    var rowNum: Int
    var colNum: Int

    // The type of each tile
    var currentLocation: BoardLocation
    var goalLocation: BoardLocation
    var obstacleLocations: [BoardLocation]
    var originLocation: BoardLocation
}

// Returned by model layer when performAction is called.
enum ActionType {
    // Tells the front-end to advance the player to given BoardLocation
    case advanceTo(BoardLocation) // This is associated value. Location that the player/head will advance to.
    
    // Tells the front-end to perform undo action
    case undo
    
    // Tells the front-end to perform action related to winning.
    case win
    
    // The direction given by the user is invalid
    case invalid(Direction)
}

// All the back-end requirements that I may need - wxz
// Implement to the class that will handle all the user interactions
protocol GameLogicDelegate {
    
    func getBoard(/* height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int */) -> BoardInfo
    func move(with direction: Direction) -> ActionType
    
}
