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
        self.currentState = self.initBoard(height: height, width: width, playerRow: playerRow, playerCol: playerCol, goalRow: goalRow, goalCol: goalCol)
    }
    
    func initBoard(height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) -> BoardInfo {
        var ret: BoardInfo
        if (playerRow >= height || playerCol >= width || goalRow >= height || goalCol >= width) {
            print("Please double check the player and goal position.");
            ret.rowNum = -1
            ret.colNum = -1
            ret.originLocation = BoardLocation.init(x: -1, y: -1)
            ret.goalLocation = BoardLocation.init(x: -1, y: -1)
            ret.levelPassed = true
            ret.obstacleLocations = []
            ret.trailLocations = []
            return ret;
        }
        else {
            ret.rowNum = -1
            ret.colNum = -1
            ret.originLocation = BoardLocation.init(row: playerRow, col: playerCol)
            ret.goalLocation = BoardLocation.init(row: goalRow, col: goalCol)
            ret.obstacleLocations = []
            ret.levelPassed = false
            ret.trailLocations = []
            return ret;
        }
    }
    
    func addRandomObstacles(count: Int) {
        var empty = self.currentState.obstacleLocations.count + self.currentState.trailLocations.count
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
                while self.currentState.obstacleLocations.contains(BoardLocation.init(row: randRow, col: randCol)) {
                    randRow = Int.random(in: 0 ..< self.currentState.rowNum);
                    randCol = Int.random(in: 0 ..< self.currentState.colNum);
                } // TODO: if already an obst, trail, goal or player, random to new number (I don't know how to)
                self.currentState.obstacleLocations.append(BoardLocation.init(row: randRow, col: randCol))
            }
        }
    }
    
    func rotateClockwise() {
        // rotated[i][j] = self.board[origH - j - 1][i]
        var new: BoardInfo
        let previousRowCount: Int = self.currentState.rowNum
        let previousColCount: Int = self.currentState.colNum
        new.colNum = previousRowCount
        new.rowNum = self.currentState.rowNum - previousColCount - 1
        
        self.currentState = new
    }
    
    func moveRight() {
        
    }
    
    func move(dir: Direction) {
        
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
        return true
    }
    
    func performAction(with direction: Direction) -> ActionType {
        <#code#>
    }
}
