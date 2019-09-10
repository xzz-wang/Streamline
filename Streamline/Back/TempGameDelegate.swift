//
//  TempGameDelegate.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/14/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

typealias Loc = BoardLocation

class TempGameDelegate: GameLogicDelegate, Codable {
    
    // MARK: - Player & Levels Info
    var highestUnlockedLevel: Int = 0
    var currentLevel = -1
    
    static let levels = [
        BoardInfo(rowNum: 6, colNum: 5, goalLocation: Loc(row: 0, col: 4), obstacleLocations: [Loc(row: 1, col: 3), Loc(row: 3, col: 2), Loc(row: 4, col: 2)], originLocation: Loc(row: 0, col: 0))
    ]
    
    public func getHighestUnlockedLevel() -> Int {
        return highestUnlockedLevel
    }
    
    func getNumOfLevels() -> Int {
        return TempGameDelegate.levels.count
    }
    
    
    // MARK: - Initializing a new game
    
    private var playerLocation: BoardLocation!
    private var trailLocations: [BoardLocation] = []
    private var currentLevel: BoardInfo!
    
    func getBoard(with level: Int) -> BoardInfo? {
        
        // Check if this level exists
        if level >= getNumOfLevels() {
            print("Level out of bounds!")
            return nil
        }
        
        return TempGameDelegate.levels[level]
    }
    
    func getBoard() -> BoardInfo? {
        currentLevel += 1
        return getBoard(currentLevel)
    }
    
    
    // MARK: - Handle game actions
    
    func move(with direction: Direction) -> ActionType {
        return ActionType.win(BoardLocation(row: 0, col: 1))
    }
    
}
