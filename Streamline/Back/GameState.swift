//
//  GameState2.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/8/7.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

public class GameState: GameLogicDelegate {
    
    // how many rotation required to return to the original status
    let rotate360: Int = 4;
    
    var currentState: BoardInfo
    var previousMoves: [Direction]
    
    public init (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) {
        self.currentState = BoardInfo.init(height: height, width: width, playerRow: playerRow, playerCol: playerCol, goalRow: goalRow, goalCol: goalRow)
        self.previousMoves = []
    }
    
    public init() {
        self.currentState = BoardInfo.init()
        self.previousMoves = []
    }
    
    func initBoard (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) -> BoardInfo {
        return self.currentState
    }
    
    func occupiedLocation (row: Int, col: Int) -> Bool {
        if self.currentState.obstacleLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.currentState.trailLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.currentState.goalLocation == BoardLocation(row: row, col: col) {
            return true
        }
        if self.currentState.currentLocation == BoardLocation(row: row, col: col) {
            return true
        }
        return false
    }
    
    func addRandomObstacles(count: Int) {
        let empty = self.currentState.obstacleLocations.count + self.currentState.trailLocations.count
        if (count > empty) {
            print("Please enter a number no greater than the amount empty spaces on the board. ");
            print("count: \(count), empty: \(empty)")
            return;
        }
        else {
            var total = 0;
            while (total < count) {
                var randRow = Int.random(in: 0 ..< self.currentState.rowNum);
                var randCol = Int.random(in: 0 ..< self.currentState.colNum);
                while occupiedLocation(row: randRow, col: randCol) {
                    randRow = Int.random(in: 0 ..< self.currentState.rowNum);
                    randCol = Int.random(in: 0 ..< self.currentState.colNum);
                }
                self.currentState.obstacleLocations.append(BoardLocation(row: randRow, col: randCol))
                total += 1
            }
        }
    }
    
    func rotateClockwise() { // TODO: still need to be tested... I kinda forgot the formula for this one
        // original formula: on the 2D array, rotated[i][j] = original[origH - j - 1][i]
        var new: BoardInfo = BoardInfo.init()
        
        // update col & row num
        let previousRowCount: Int = self.currentState.rowNum
        let previousColCount: Int = self.currentState.colNum
        new.colNum = previousRowCount
        new.rowNum = self.currentState.rowNum - previousColCount - 1
        
        // update original
        let previousOriginalRow: Int = self.currentState.currentLocation.row
        let previousOriginalCol: Int = self.currentState.currentLocation.column
        new.currentLocation = BoardLocation.init(x: self.currentState.currentLocation.row - previousOriginalCol - 1,
                                                 y: previousOriginalRow)
        
        // update goal
        let previousGoalRow: Int = self.currentState.goalLocation.row
        let previousGoalCol: Int = self.currentState.goalLocation.column
        new.goalLocation = BoardLocation.init(x: self.currentState.goalLocation.row - previousGoalCol - 1,
                                              y: previousGoalRow)
        
        // update trails and obstacles
        var newObsts: [BoardLocation] = Array.init()
        for bl in self.currentState.obstacleLocations {
            let origX = bl.x
            let origY = bl.y
            let newLocation = BoardLocation.init(x: previousRowCount - origY - 1, y: origX)
            newObsts.append(newLocation)
        }
        new.obstacleLocations = newObsts
        var newTrails: [BoardLocation] = Array.init()
        for bl in self.currentState.trailLocations {
            let origX = bl.x
            let origY = bl.y
            let newLocation = BoardLocation.init(x: previousRowCount - origY - 1, y: origX)
            newTrails.append(newLocation)
        }
        new.trailLocations = newTrails
        
        self.currentState = new
    }
    
    func moveRight() -> BoardLocation {
        while !occupiedLocation(row: self.currentState.currentLocation.row, col: self.currentState.currentLocation.column + 1) {
            self.currentState.trailLocations.append(self.currentState.currentLocation)
            self.currentState.currentLocation.column += 1
            if self.currentState.currentLocation == self.currentState.goalLocation {
                self.currentState.levelPassed = true
                break
            }
        } // TODO: test if the loop condition causes the player to never move
        return self.currentState.currentLocation
    }
    
    func move(with dir: Direction) -> ActionType {
        let rotationCount: Int = dir.rawValue
        let previousLocation: BoardLocation = self.currentState.currentLocation
        
        // if undo
        if (dir == Direction.up && previousMoves[previousMoves.count - 1] == Direction.down) {
            return ActionType.undo
        }
        if (dir == Direction.down && previousMoves[previousMoves.count - 1] == Direction.up) {
            return ActionType.undo
        }
        if (dir == Direction.left && previousMoves[previousMoves.count - 1] == Direction.right) {
            return ActionType.undo
        }
        if (dir == Direction.right && previousMoves[previousMoves.count - 1] == Direction.left) {
            return ActionType.undo
        }

        // not undo, try to move player
        for _ in 0..<rotationCount {
            self.rotateClockwise()
        }
        _ = self.moveRight() // just to suppress warning
        for _ in rotationCount..<rotate360 {
            self.rotateClockwise()
        }
        if self.currentState.levelPassed == true {
            return ActionType.win
        }
        else if self.currentState.currentLocation == previousLocation {
            return ActionType.invalid(dir)
        }
        else {
            return ActionType.advanceTo(self.currentState.currentLocation)
        }
    }
    
    // can only make it print to console now, but should be good enough
    // formerly toString
    public func printBoard() {
        let col: [Character] = Array.init(repeating: " ", count: self.currentState.colNum)
        var board: [[Character]] = Array.init(repeating: col, count: self.currentState.rowNum)
        for location in currentState.obstacleLocations {
            board[location.row][location.column] = "X"
        }
        for location in currentState.trailLocations {
            board[location.row][location.column] = "."
        }
        board[self.currentState.currentLocation.row][self.currentState.currentLocation.column] = "O"
        board[self.currentState.goalLocation.row][self.currentState.goalLocation.column] = "G"
        print(board)
    }
    
    public func equals(toCheck: GameState) -> Bool {
        if self.previousMoves != toCheck.previousMoves {
            return false
        }
        if self.currentState.rowNum != toCheck.currentState.rowNum {
            return false
        }
        if self.currentState.colNum != toCheck.currentState.colNum {
            return false
        }
        if self.currentState.levelPassed != toCheck.currentState.levelPassed {
            return false
        }
        if self.currentState.currentLocation != toCheck.currentState.currentLocation {
            return false
        }
        if self.currentState.goalLocation != toCheck.currentState.goalLocation {
            return false
        }
        if self.currentState.obstacleLocations != toCheck.currentState.obstacleLocations {
            return false
        }
        if self.currentState.trailLocations != toCheck.currentState.trailLocations {
            return false
        }
        return true
    }
}
