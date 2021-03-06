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
    
    // Row and column are basicially the same as x and y. Just in case someone got confused.
    // MARK: x, y, row, col all starts with 0.
    var row: Int {
        get { return y }
        set { y = newValue }
    }
    
    var column: Int {
        get { return x }
        set { x = newValue }
    }

    
    // Initializers
    init(x: Int, y:Int) {
        self.x = x
        self.y = y
    }
    
    init(row: Int, col:Int) {
        self.x = col
        self.y = row
    }
    
    static func == (this: BoardLocation, that: BoardLocation) -> Bool {
        return this.x == that.x && this.y == that.y
    }
    
    func getNeighbor(of direction: Direction) -> BoardLocation {
        switch direction {
        case .up:
            return BoardLocation(row: self.row - 1, col: self.column)
        case .down:
            return BoardLocation(row: self.row + 1, col: self.column)
        case .left:
            return BoardLocation(row: self.row, col: self.column - 1)
        case .right:
            return BoardLocation(row: self.row, col: self.column + 1)
        }
    }
    
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
    var goalLocation: BoardLocation
    var obstacleLocations: [BoardLocation]
    var originLocation: BoardLocation
    
    func contains(_ location: BoardLocation) -> Bool {
        let row = location.row
        let col = location.column
        
        if row >= rowNum || row < 0 {
            return false
        } else if col >= colNum || col < 0 {
            return false
        }
        
        return true
    }
}

// Returned by model layer when performAction is called.
enum ActionType: Equatable {
    // Tells the front-end to advance the player to given BoardLocation
    case advanceTo(BoardLocation) // This is associated value. Location that the player/head will advance to.
    
    // Tells the front-end to perform undo action
    case undo
    
    // Tells the front-end to perform action related to winning.
    case win(BoardLocation)
    
    // The direction given by the user is invalid
    case invalid(Direction)
}

// All the back-end requirements that I may need - wxz
// Implement to the class that will handle all the user interactions
protocol GameLogicDelegate {
    
    // Get info about the levels
    
    func getHighestUnlockedLevel() -> Int
    
    func getNumLevels() -> Int
    
    // Resume game, or automatically advance to the next level
    func getBoard() -> BoardInfo?
    
    // Get a specific unlocked level.
    func getBoard(with level: Int) -> BoardInfo?
    
    // In each level, the user will try to move in the following directions.
    func move(with direction: Direction) -> ActionType
    
    // When won, check if there's a match between actual goal location and the final location of player, and if so, vibrate the device's taptic engine
    func getGoalLocation() -> BoardLocation
}
