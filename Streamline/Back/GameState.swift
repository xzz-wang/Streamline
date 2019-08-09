//
//  GameState.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/7/31.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

//import Foundation
//
//public class GameState: GameLogicDelegate {
//    // Used to populate char[][] board below and to display the
//    // current state of play.
//    let TRAIL_CHAR: Character = ".";
//    let OBSTACLE_CHAR: Character = "X";
//    let SPACE_CHAR: Character = " ";
//    let CURRENT_CHAR: Character = "O";
//    let GOAL_CHAR: Character = "@";
//    let NEWLINE_CHAR: Character = "\n";
//
//    // used to format the toString() method about the upper & lower border's
//    // length
//    let BORDER_MULTIPLIER: Int = 2;
//    let BORDER_APPENDER: Int = 3;
//
//    // how many rotation required to return to the original status
//    let rotate360: Int = 4;
//
//    // This represents a 2D map of the board
//    var board: [[Character]];
//
//    // Location of the player
//    var playerRow: Int;
//    var playerCol: Int;
//
//    // Location of the goal
//    var goalRow: Int;
//    var goalCol: Int;
//
//    // true means the player completed this level
//    var levelPassed: Bool;
//
//    /** Constructor: GameState
//     * Will initialize a board of given parameters
//     * And fill the board with SPACE_CHAR
//     * Those corresponding fields will be set to parameters.
//     * If the goal or player position is off the board will terminate the
//     *     method and tell the user to change another input.
//     * */
//    func initBoard (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) -> BoardInfo {
//        var ret: BoardInfo
//        if (playerRow >= height || playerCol >= width || goalRow >= height || goalCol >= width) {
//            print("Please double check the player and goal position parameter.");
//            ret.rowNum = -1
//            ret.colNum = -1
//            ret.originLocation = BoardLocation.init(x: -1, y: -1)
//            ret.goalLocation = BoardLocation.init(x: -1, y: -1)
//            ret.levelPassed = true
//            ret.obstacleLocations = []
//            ret.trailLocations = []
//            return ret;
//        }
//        else {
//            ret.rowNum = -1
//            ret.colNum = -1
//            ret.originLocation = BoardLocation.init(row: playerRow, col: playerCol)
//            ret.goalLocation = BoardLocation.init(row: goalRow, col: goalCol)
//            ret.obstacleLocations = []
//            ret.levelPassed = false
//            ret.trailLocations = []
//            return ret;
//        }
//    }
//
//    public init (height: Int, width: Int, playerRow: Int, playerCol: Int, goalRow: Int, goalCol: Int) {
//        if (playerRow >= height || playerCol >= width || goalRow >= height || goalCol >= width) {
//            print("Please double check the player and goal position parameter.");
//            self.board = [Array.init(repeating: SPACE_CHAR, count: 1)]
//            self.playerCol = -1 // self in Swift = this in Java
//            self.playerRow = -1
//            self.goalRow = -1
//            self.goalCol = -1
//            self.levelPassed = true
//        }
//        else {
//            self.board = [Array.init(repeating: SPACE_CHAR, count: height * width)]
//            self.playerRow = playerRow;
//            self.playerCol = playerCol;
//            self.goalRow = goalRow;
//            self.goalCol = goalCol;
//            self.levelPassed = (playerCol == goalCol) && (playerRow == goalRow);
//        }
//    }
//
//    /** Copier: GameState (the second constructor method in this class)
//     * Will copy whatever the state of another board is
//     * Deep copy that will loop through every element in the array to
//     *     populate a new array for the char[][] board
//     * */
//    public init (other: GameState) {
//        self.playerRow = other.playerRow;
//        self.playerCol = other.playerCol;
//        self.goalRow = other.goalRow;
//        self.goalCol = other.goalCol;
//        self.levelPassed = other.levelPassed; // checkpoint edge case
//        self.board = [[]]
//        for i in 0...other.board.count {
//            for j in 0...other.board[0].count {
//                self.board[i][j] = other.board[i][j];
//            }
//        }
//    }
//
//    /** Method: addRandomObstacles
//     * add count-many of random blocks into this.board
//     * the player should stop moving when ran into it
//     * @param count: how many obstacles we want to put onto the board
//     * Will check if count exceeds the number of empty spaces
//     * Will check if it is an occupied place, i.e. player, goal or already
//     *     have something in the block
//     * */
//    public func addRandomObstacles(count: Int) {
//        var empty = 0;
//        for i in 0...self.board.count {
//            for j in 0...self.board[0].count {
//                if (board[i][j] != TRAIL_CHAR && board[i][j] != OBSTACLE_CHAR) {
//                    if (i == playerRow && j == playerCol) {
//                        continue
//                    }
//                    if (i == goalRow && j == goalCol) {
//                        continue
//                    }
//                    empty += 1;
//                }
//            }
//        } // count how many empty places are remaining on the board
//        if (count > empty) {
//            print("Please enter a number no greater than the amount empty spaces on the board. ");
//            print("count: \(count), empty: \(empty)")
//            return;
//        }
//        else {
//            var total = 0;
//            while (total < count) {
//                let randRow = Int.random(in: 0 ..< self.board.count);
//                let randCol = Int.random(in: 0 ..< self.board[0].count);
//                // set up random int no greater than width & height
//                if (self.board[randRow][randCol] != TRAIL_CHAR && self.board[randRow][randCol] != OBSTACLE_CHAR) {
//                    if (randRow == playerRow && randCol == playerCol) {
//                        continue;
//                    }
//                    if (randRow == goalRow && randCol == goalCol) {
//                        continue;
//                    }
//                    self.board[randRow][randCol] = OBSTACLE_CHAR;
//                    total += 1;
//                } // as long as it's empty we can set an obstacle
//            }
//        }
//    }
//
//    /** Method: rotateClockwise
//     * Will rotate everything on the playing board clockwise once, including
//     *     player's, goal's and obstacles' position
//     * */
//    public func rotateClockwise() {
//        let origH = self.board.count;
//        let origW = self.board[0].count;
//        var rotated: [[Character]] = [[]];
//        for i in 0...origW {
//            for j in 0...origH {
//                rotated[i][j] = self.board[origH - j - 1][i];
//            }
//        }
//        let newPC = origH - self.playerRow - 1;
//        let newPR = self.playerCol;
//        let newGC = origH - self.goalRow - 1;
//        let newGR = self.goalCol;
//
//        self.playerCol = newPC;
//        self.playerRow = newPR;
//        self.goalCol = newGC;
//        self.goalRow = newGR;
//        self.board = rotated;
//    }
//
//
//    /** Method: moveRight
//     * First check if the player has passed the level or not, if so
//     *     will print a message saying so and stop from further moving
//     * Keep moving the player's position to the right, i.e. adding its column
//     *     index as long as there's nothing in the next block
//     * If the player meets the goal at some time in the middle, will return
//     *     directly from the game
//     * */
//    public func moveRight() {
//        if (self.levelPassed == true) {
//            print("You've passed this level, there's no need to keep moving. ");
//            return;
//        }
//        else {
//            let nowRow = self.playerRow;
//            var nowCol = self.playerCol;
//            while ((nowCol + 1 < self.board[nowRow].count) && (self.board[nowRow][nowCol + 1] != OBSTACLE_CHAR) && (self.board[nowRow][nowCol + 1] != TRAIL_CHAR)) {
//                self.board[nowRow][nowCol] = TRAIL_CHAR;
//                nowCol += 1;
//                if (nowRow == self.goalRow && nowCol == self.goalCol) {
//                    self.levelPassed = true;
//                    self.playerCol = nowCol;
//                    return;
//                }
//                self.playerCol = nowCol;
//            }
//        }
//    }
//
//    func move(direction: Direction) {
//        let rotationCount: Int = direction.rawValue
//        for _ in 0...rotationCount {
//            self.rotateClockwise()
//        }
//        self.moveRight()
//        for _ in 0...(4 - rotationCount) {
//            self.rotateClockwise()
//        }
//    }
//
//    func performAction(with direction: Direction) -> ActionType {
//        return ActionType.win
//    }
//
//    public func toString() -> String {
//        var ret: String = ""
//        for _ in 0...(BORDER_MULTIPLIER * self.board[0].count + BORDER_APPENDER) {
//            ret += "-"
//        }
//        for i in 0...self.board.count {
//            ret += "|"
//            for j in 0...self.board[0].count {
//                if (self.board[i][j] == OBSTACLE_CHAR) {
//                    ret += "X"
//                }
//                else if (self.board[i][j] == TRAIL_CHAR) {
//                    ret += "."
//                }
//                else if (self.board[i][j] == SPACE_CHAR) {
//                    ret += " "
//                }
//                else if (i == self.playerRow && j == self.playerCol) {
//                    ret += "O"
//                }
//                else if (i == self.goalRow && j == self.goalCol) {
//                    ret += "@"
//                }
//                ret += " "
//            }
//            ret += "|"
//            ret += "\n"
//        }
//        for _ in 0...(BORDER_MULTIPLIER * self.board[0].count + BORDER_APPENDER) {
//            ret += "-"
//        }
//        return ret
//    }
//
//    public func equals(toCheck: GameState) -> Bool {
//        if (toCheck.goalRow != self.goalRow) {return false}
//        if (toCheck.goalCol != self.goalCol) {return false}
//        if (toCheck.playerCol != self.playerCol) {return false}
//        if (toCheck.playerRow != self.playerRow) {return false}
//        if (toCheck.levelPassed != self.levelPassed) {return false}
//        if (toCheck.board.count != self.board.count) {return false}
//        if (toCheck.board[0].count != self.board[0].count) {return false}
//        for i in 0...toCheck.board.count {
//            for j in 0...toCheck.board[0].count {
//                if toCheck.board[i][j] != self.board[i][j] {
//                    return false
//                }
//            }
//        }
//        return true
//    }
//}
