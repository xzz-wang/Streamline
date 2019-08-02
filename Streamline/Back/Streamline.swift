//
//  Streamline.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/7/31.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

public class Streamline {
    var currentState: GameState
    var previousStates: Array<GameState>
    var previousDirections: Array<String>
    
    public init() {
        currentState = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4)
        currentState.addRandomObstacles(count: 3)
        previousStates = Array.init()
        previousDirections = Array.init()
    }
    
    //TODO: public init (file: String) {} // initializer from the board written to a text file
    
    public func play() {
        while !currentState.levelPassed {
            print(currentState.toString())
            print("> ")
            let lastStep: GameState = GameState.init(other: currentState)
            
            // TODO: takes user input and moves the board. Use self.recordAndMove(Direction)
            
            if lastStep.equals(other: currentState) {
                continue
            }
            else {
                previousStates.append(lastStep)
            }
        }
        print("Level passed! ")
    }
    
    public func recordAndMove(dir: String) {
        if (dir != "UP" || dir != "DOWN" || dir != "LEFT" || dir != "RIGHT") {
            // if direction is not a valid string input
        }
        // 4 moves, pause, quit, save, undo. Also check last move to see if it's undo
    }
    
    public func undo() {
        if self.previousStates.isEmpty {
            return
        }
        self.currentState = self.previousStates.remove(at: self.previousStates.count - 1)
        self.previousDirections.remove(at: self.previousDirections.count - 1)
    }
    
    public func loadFromFile() {
        
    }
    
    public func save() -> String {
        var toSave = String.init()
        toSave += "\(currentState.board.count) \(currentState.board[0].count)"
        toSave += "\(currentState.playerRow) \(currentState.playerCol)"
        toSave += "\(currentState.goalRow) \(currentState.goalCol)"
        for i in 0...currentState.board.count {
            for j in 0...currentState.board[0].count {
                if currentState.board[i][j] == " " {
                    toSave += " "
                } // empty block
                else if currentState.board[i][j] == "X" {
                    toSave += "X"
                } // obstacle
                else if currentState.board[i][j] == "." {
                    toSave += "."
                } // trail
                // toSave += currentState.board[i][j]
                toSave += "\n" // start a new line after each row of the board
            }
        }
        return toSave
    }
}
