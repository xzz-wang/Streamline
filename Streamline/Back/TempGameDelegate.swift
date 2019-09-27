//
//  TempGameDelegate.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/14/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

typealias Loc = BoardLocation

class TempGameDelegate: GameLogicDelegate {    
    
    // MARK: - Player & Levels Info
    var highestUnlockedLevel: Int = 0
    var currentLevel = -1
    
    static let levels = [
        BoardInfo(rowNum: 6, colNum: 5, goalLocation: Loc(row: 0, col: 4), obstacleLocations: [Loc(row: 1, col: 3), Loc(row: 3, col: 2), Loc(row: 4, col: 2)], originLocation: Loc(row: 5, col: 0)),
        BoardInfo(rowNum: 6, colNum: 5, goalLocation: Loc(row: 0, col: 4), obstacleLocations: [Loc(row: 0, col: 2), Loc(row: 2, col: 3), Loc(row: 5, col: 4)], originLocation: Loc(row: 5, col: 0)),
        BoardInfo(rowNum: 6, colNum: 5, goalLocation: Loc(row: 0, col: 4), obstacleLocations: [Loc(row: 0, col: 1), Loc(row: 2, col: 4), Loc(row: 3, col: 1)], originLocation: Loc(row: 5, col: 0)),
        BoardInfo(rowNum: 6, colNum: 5, goalLocation: Loc(row: 0, col: 4), obstacleLocations: [Loc(row: 1, col: 4), Loc(row: 2, col: 0), Loc(row: 2, col: 2), Loc(row: 3, col: 3), Loc(row: 4, col: 1), Loc(row: 5, col: 2)], originLocation: Loc(row: 5, col: 0)),
    ]
    
    public func getHighestUnlockedLevel() -> Int {
        return highestUnlockedLevel
    }
    
    func getNumLevels() -> Int {
        return TempGameDelegate.levels.count
    }
    
    
    // MARK: - Initializing a new game
    
    private var playerLocation: BoardLocation!
    private var trailLocations: [BoardLocation] = []
    private var currentLevelInfo: BoardInfo!
    
    private var pastActions: [Direction] = []
    private var pastLocations: [BoardLocation] = []
    private var pastSteps: [Int] = []
    private var currentStep = 0
    
    func getBoard(with level: Int) -> BoardInfo? {
        
        // Check if this level exists
        if level >= getNumLevels() {
            print("Level out of bounds!")
            return nil
        }
        
        // Switch to this level
        currentLevelInfo = TempGameDelegate.levels[level]
        
        // Initialize the player locations and other things
        playerLocation = currentLevelInfo.originLocation
        trailLocations = []
        pastActions = []
        pastLocations = []
        
        return currentLevelInfo
    }
    
    func getBoard() -> BoardInfo? {
        currentLevel += 1
        return getBoard(with: currentLevel)  
    }
    
    
    // MARK: - Handle game actions
    
    func move(with direction: Direction) -> ActionType {
        
        // Check if this move is an undo
        if let lastAction = pastActions.last {
            var isUndo = false
            switch lastAction {
            case .up:
                isUndo = direction == .down
            case .down:
                isUndo = direction == .up
            case .left:
                isUndo = direction == .right
            case .right:
                isUndo = direction == .left
            }
            
            if isUndo {
                pastActions.removeLast()
                playerLocation = pastLocations.popLast()
                
                for _ in 0..<currentStep {
                    trailLocations.removeLast()
                }
                
                currentStep = pastSteps.popLast()!
                return .undo
            }
        }
        
        // Not undo, do other things.
        var returnValue: ActionType!
        var moved = false
        
        // Loop till we can no long move
        while true {
            
            // This step's target location
            let targetLocation = playerLocation.getNeighbor(of: direction)
            
            var willStop = false
            
            // Stop 1: Reached the edge of the board
            if !currentLevelInfo.contains(targetLocation) {
                // Reached the edge of board.
                willStop = true
            }
            
            // Stop 2: Run into obstacles
            if !willStop {
                for obstacle in currentLevelInfo.obstacleLocations {
                    if targetLocation == obstacle {
                        // Run into obstacle!
                        willStop = true
                        break
                    }
                }
            }
            
            // Stop 3: Run into trail
            if !willStop {
                for trail in trailLocations {
                    if targetLocation == trail {
                        willStop = true
                        break
                    }
                }
            }
            
            // handle stop
            if willStop {
                if moved {
                    returnValue = .advanceTo(playerLocation)
                    break
                } else {
                    returnValue = .invalid(direction)
                    break
                }
            }
            
            // Not edge, trail, nor obstacle, let's move
            
            // log this action if this is the first time moving
            if !moved {
                // Append this direction to the past actions
                pastActions.append(direction)
                // Append the past player location to the pastLocations
                pastLocations.append(playerLocation)
                pastSteps.append(currentStep)
                currentStep = 0
            }
            moved = true
            
            // Actually moving
            trailLocations.append(playerLocation)
            playerLocation = targetLocation
            currentStep += 1
            
            // Check if we won
            if playerLocation == currentLevelInfo.goalLocation {
                returnValue = .win(playerLocation)
                break
            }
            
        }
        
        return returnValue
    }
    
    func getGoalLocation() -> BoardLocation {
        return currentLevelInfo.goalLocation
    }
    
}
