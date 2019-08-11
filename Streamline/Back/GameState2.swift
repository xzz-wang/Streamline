//
//  GameState2.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/8/7.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

public class GameState2: GameLogicDelegate {
    
    // Used to populate char[][] board below and to display the
    // current state of play.
    let TRAIL_CHAR: Character = ".";
    let OBSTACLE_CHAR: Character = "X";
    let SPACE_CHAR: Character = " ";
    let CURRENT_CHAR: Character = "O";
    let GOAL_CHAR: Character = "@";
    let NEWLINE_CHAR: Character = "\n";
    
    // used to format the toString() method about the upper & lower border's
    // length
    let BORDER_MULTIPLIER: Int = 2;
    let BORDER_APPENDER: Int = 3;
    
    // how many rotation required to return to the original status
    let rotate360: Int = 4;
    
    var currentState: BoardInfo
    
    public init (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) {
        self.currentState = BoardInfo.init(height: height, width: width, playerRow: playerRow, playerCol: playerCol, goalRow: goalRow, goalCol: goalRow)
    }
    
    func initBoard(height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) -> BoardInfo {
        return self.currentState
    }
    
    func occupiedLocation(row: Int, col: Int) -> Bool {
        if self.currentState.obstacleLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.currentState.trailLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.currentState.goalLocation == BoardLocation(row: row, col: col) {
            return true
        }
        if self.currentState.originLocation == BoardLocation(row: row, col: col) {
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
        let previousOriginalRow: Int = self.currentState.originLocation.row
        let previousOriginalCol: Int = self.currentState.originLocation.column
        new.originLocation = BoardLocation.init(x: self.currentState.originLocation.row - previousOriginalCol - 1,
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
    
    func moveRight() {
        
    }
    
    func move(dir: Direction) {
        let rotationCount: Int = dir.rawValue
        for _ in 0..<rotationCount {
            self.rotateClockwise()
        }
        self.moveRight()
        for _ in rotationCount..<4 {
            self.rotateClockwise()
        }
    }
    
    // TODO: can only make it print to console now, but should be good enough
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
        board[self.currentState.originLocation.row][self.currentState.originLocation.column] = "O"
        board[self.currentState.goalLocation.row][self.currentState.goalLocation.column] = "G"
        printBoard() // or print(board)??
    }
    
    public func equals(toCheck: GameState2) -> Bool {
        return false
    }
    
    func performAction(with direction: Direction) -> ActionType {
        return ActionType.invalid(direction)
    }
}
