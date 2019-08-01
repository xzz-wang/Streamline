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
        while currentState.levelPassed != true {
            print(currentState.toString())
            print("> ")
            let lastStep: GameState = GameState.init(other: currentState)
            
            // TODO: takes user input and moves the board
            
            if lastStep.equals(other: currentState) {
                continue
            }
            else {
                previousStates.append(lastStep)
                
            }
        }
    }
    
    public func recordAndMove(dir: String) {
        
    }
    
    public func undo() {
        
    }
    
    public func loadFromFile() {
        
    }
    
    public func saveToFile() {
        
    }
}
