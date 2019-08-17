//
//  GameState.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/8/7.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

public class GameState: GameLogicDelegate {
    func getBoard() -> BoardInfo {
        return self.board
    }

    // how many rotation required to return to the original status
    let rotate360: Int = 4;

    var board: BoardInfo
    var currentLocation: BoardLocation
    var trailLocations: [BoardLocation]
    var previousMoves: [Direction]
    var levelPassed: Bool

    public init (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) {
        self.board = BoardInfo.init(rowNum: height, colNum: width,
                                    goalLocation: BoardLocation.init(row: goalRow, col: goalCol),
                                    obstacleLocations: [],
                                    originLocation: BoardLocation.init(row: playerRow, col: playerCol)
                                   )
        self.currentLocation = self.board.originLocation
        self.trailLocations = []
        self.previousMoves = []
        self.levelPassed = false
    }

    public init() {
        self.board = BoardInfo.init(rowNum: 6, colNum: 5,
                                    goalLocation: BoardLocation.init(row: 5, col: 0),
                                    obstacleLocations: [],
                                    originLocation: BoardLocation.init(row: 0, col: 4)
                                    )
        self.currentLocation = self.board.originLocation
        self.trailLocations = []
        self.previousMoves = []
        self.levelPassed = false
        self.addRandomObstacles(count: 3)
    }

    func initBoard (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) -> BoardInfo {
        return self.board
    }

    func occupiedLocation (row: Int, col: Int) -> Bool {
        if self.board.obstacleLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.board.obstacleLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.board.goalLocation == BoardLocation(row: row, col: col) {
            return true
        }
        if self.currentLocation == BoardLocation(row: row, col: col) {
            return true
        }
        return false
    }

    func addRandomObstacles(count: Int) {
        let empty = self.board.obstacleLocations.count + self.trailLocations.count
        if (count > empty) {
            print("Please enter a number no greater than the amount empty spaces on the board. ");
            print("count: \(count), empty: \(empty)")
            return;
        }
        else {
            var total = 0;
            while (total < count) {
                var randRow = Int.random(in: 0 ..< self.board.rowNum);
                var randCol = Int.random(in: 0 ..< self.board.colNum);
                while occupiedLocation(row: randRow, col: randCol) {
                    randRow = Int.random(in: 0 ..< self.board.rowNum);
                    randCol = Int.random(in: 0 ..< self.board.colNum);
                }
                self.board.obstacleLocations.append(BoardLocation(row: randRow, col: randCol))
                total += 1
            }
        }
    }

    func rotateClockwise() { // TODO: still need to be tested... I kinda forgot the formula for this one
        // original formula: on the 2D array, rotated[i][j] = original[origH - j - 1][i]
        var new: BoardInfo = BoardInfo.init(rowNum: self.board.colNum, colNum: self.board.rowNum,
                                            goalLocation: BoardLocation.init(row: 0, col: 4),
                                            obstacleLocations: [],
                                            originLocation: BoardLocation.init(row: 5, col: 0))
        
//        self.board = BoardInfo.init(rowNum: height, colNum: width,
//                                    goalLocation: BoardLocation.init(row: goalRow, col: goalCol),
//                                    obstacleLocations: [],
//                                    originLocation: BoardLocation.init(row: playerRow, col: playerCol)
//        )
//
        // update col & row num
        let previousRowCount: Int = self.board.rowNum
        let previousColCount: Int = self.board.colNum
        new.colNum = previousRowCount
        new.rowNum = self.board.rowNum - previousColCount - 1

        // update original
        let previousOriginalRow: Int = self.currentLocation.row
        let previousOriginalCol: Int = self.currentLocation.column
        self.currentLocation = BoardLocation.init(x: self.currentLocation.row - previousOriginalCol - 1,
                                                 y: previousOriginalRow)

        // update goal
        let previousGoalRow: Int = self.board.goalLocation.row
        let previousGoalCol: Int = self.board.goalLocation.column
        new.goalLocation = BoardLocation.init(x: self.board.goalLocation.row - previousGoalCol - 1,
                                              y: previousGoalRow)

        // update trails and obstacles
        var newObsts: [BoardLocation] = Array.init()
        for bl in self.board.obstacleLocations {
            let origX = bl.x
            let origY = bl.y
            let newLocation = BoardLocation.init(x: previousRowCount - origY - 1, y: origX)
            newObsts.append(newLocation)
        }
        new.obstacleLocations = newObsts
        var newTrails: [BoardLocation] = Array.init()
        for bl in self.trailLocations {
            let origX = bl.x
            let origY = bl.y
            let newLocation = BoardLocation.init(x: previousRowCount - origY - 1, y: origX)
            newTrails.append(newLocation)
        }
        self.trailLocations = newTrails

        self.board = new
    }

    func moveRight() -> BoardLocation {
        while !occupiedLocation(row: self.currentLocation.row, col: self.currentLocation.column + 1) {
            self.trailLocations.append(self.currentLocation)
            self.currentLocation.column += 1
            if self.currentLocation == self.board.goalLocation {
                self.levelPassed = true
                break
            }
        } // TODO: test if the loop condition causes the player to never move
        return self.currentLocation
    }

    func move(with dir: Direction) -> ActionType {
        let rotationCount: Int = dir.rawValue
        let previousLocation: BoardLocation = self.currentLocation

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
        if self.levelPassed == true {
            return ActionType.win
        }
        else if self.currentLocation == previousLocation {
            return ActionType.invalid(dir)
        }
        else {
            return ActionType.advanceTo(self.currentLocation)
        }
    }

    // can only make it print to console now, but should be good enough
    // formerly toString
    public func printBoard() {
        let col: [Character] = Array.init(repeating: " ", count: self.board.colNum)
        var board: [[Character]] = Array.init(repeating: col, count: self.board.rowNum)
        for location in self.board.obstacleLocations {
            board[location.row][location.column] = "X"
        }
        for location in self.trailLocations {
            board[location.row][location.column] = "."
        }
        board[self.currentLocation.row][self.currentLocation.column] = "O"
        board[self.board.goalLocation.row][self.board.goalLocation.column] = "G"
        print(board)
    }

    public func equals(toCheck: GameState) -> Bool {
        if self.previousMoves != toCheck.previousMoves {
            return false
        }
        if self.board.rowNum != toCheck.board.rowNum {
            return false
        }
        if self.board.colNum != toCheck.board.colNum {
            return false
        }
        if self.levelPassed != toCheck.levelPassed {
            return false
        }
        if self.currentLocation != toCheck.currentLocation {
            return false
        }
        if self.board.goalLocation != toCheck.board.goalLocation {
            return false
        }
        if self.board.obstacleLocations != toCheck.board.obstacleLocations {
            return false
        }
        if self.trailLocations != toCheck.trailLocations {
            return false
        }
        return true
    }
}
