//
//  GameState.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/8/7.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

public class GameState {
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

    // init with height, width, player & goal location: add random obstacles, risk of no way to finish
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
        self.addRandomObstacles(count: Int(Double(height) * Double(width) * 0.1))
    }

    // init with height, width, player & goal location and obstacle locations
    init (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int, obstLocations: [BoardLocation]) {
        self.board = BoardInfo.init(rowNum: height, colNum: width,
                                    goalLocation: BoardLocation.init(row: goalRow, col: goalCol),
                                    obstacleLocations: obstLocations,
                                    originLocation: BoardLocation.init(row: playerRow, col: playerCol)
        )
        self.currentLocation = self.board.originLocation
        self.trailLocations = []
        self.previousMoves = []
        self.levelPassed = false
    }

    // default init: 6 rows, 5 cols, player on bottom left, goal on top right, some random obstacles
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

    func stopMoving (row: Int, col: Int) -> Bool {
        if self.board.obstacleLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.trailLocations.contains(BoardLocation(row: row, col: col)) {
            return true
        }
        if self.currentLocation == BoardLocation(row: row, col: col) {
            return true
        }
        if row >= self.board.rowNum || row < 0 {
            return true
        }
        if col >= self.board.colNum || col < 0 {
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
                while stopMoving(row: randRow, col: randCol) {
                    randRow = Int.random(in: 0 ..< self.board.rowNum);
                    randCol = Int.random(in: 0 ..< self.board.colNum);
                }
                self.board.obstacleLocations.append(BoardLocation(row: randRow, col: randCol))
                total += 1
            }
        }
    }

    func moveRight() {
        while !stopMoving(row: self.currentLocation.row, col: self.currentLocation.column + 1) {
            self.trailLocations.append(self.currentLocation)
            self.currentLocation.column += 1
            if self.currentLocation == self.board.goalLocation {
                self.levelPassed = true
                break
            }
        } // TODO: test if the loop condition causes the player to never move
    }

    func moveLeft() {
        while !stopMoving(row: self.currentLocation.row, col: self.currentLocation.column - 1) {
            self.trailLocations.append(self.currentLocation)
            self.currentLocation.column -= 1
            if self.currentLocation == self.board.goalLocation {
                self.levelPassed = true
                break
            }
        } // TODO: test if the loop condition causes the player to never move
    }

    func moveUp() {
        while !stopMoving(row: self.currentLocation.row - 1, col: self.currentLocation.column) {
            self.trailLocations.append(self.currentLocation)
            self.currentLocation.row -= 1
            if self.currentLocation == self.board.goalLocation {
                self.levelPassed = true
                break
            }
        } // TODO: test if the loop condition causes the player to never move
    }

    func moveDown() {
        while !stopMoving(row: self.currentLocation.row + 1, col: self.currentLocation.column) {
            self.trailLocations.append(self.currentLocation)
            self.currentLocation.row += 1
            if self.currentLocation == self.board.goalLocation {
                self.levelPassed = true
                break
            }
        } // TODO: test if the loop condition causes the player to never move
    }

    func move(with dir: Direction) -> ActionType {
        let previousLocation: BoardLocation = self.currentLocation

        // if undo
        if previousMoves.count > 0 {
            if (dir == Direction.up && previousMoves[previousMoves.count - 1] == Direction.down) {
                previousMoves.removeLast()
                return ActionType.undo
            }
            if (dir == Direction.down && previousMoves[previousMoves.count - 1] == Direction.up) {
                previousMoves.removeLast()
                return ActionType.undo
            }
            if (dir == Direction.left && previousMoves[previousMoves.count - 1] == Direction.right) {
                previousMoves.removeLast()
                return ActionType.undo
            }
            if (dir == Direction.right && previousMoves[previousMoves.count - 1] == Direction.left) {
                previousMoves.removeLast()
                return ActionType.undo
            }
        }

        // not undo, try to move player
        if dir == Direction.down {
            self.moveDown() // suppress warnings
        }
        if dir == Direction.up {
            self.moveUp()
        }
        if dir == Direction.left {
            self.moveLeft()
        }
        if dir == Direction.right {
            self.moveRight()
        }
        // self.printBoard()
        if self.levelPassed == true {
            return ActionType.win(self.currentLocation)
        }
        else if self.currentLocation == previousLocation {
            return ActionType.invalid(dir)
        }
        else {
            self.previousMoves.append(dir)
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

    func getCurrentLocation() -> BoardLocation {
        return self.currentLocation
    }
}
