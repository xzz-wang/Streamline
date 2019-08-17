//
//  Streamline.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/7/31.
//  Edited by Chongbin (Bob) Zhang & Xuezheng Wang
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

public class Streamline {
    var levels: [GameState]
    
    // with 8 sample levels: more on remote... I'm lazy hard-coding them as of now... there's also some complicated levels
    // TODO: find a way to read from files and save the games
    public init() {
        let Lv1 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 1, col: 3), BoardLocation.init(row: 3, col: 2), BoardLocation.init(row: 4, col: 2)])
        let Lv2 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 0, col: 2), BoardLocation.init(row: 2, col: 3), BoardLocation.init(row: 5, col: 4)])
        let Lv3 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 0, col: 1), BoardLocation.init(row: 2, col: 4), BoardLocation.init(row: 3, col: 1)])
        let Lv4 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 1, col: 4), BoardLocation.init(row: 2, col: 0), BoardLocation.init(row: 2, col: 2), BoardLocation.init(row: 3, col: 3), BoardLocation.init(row: 4, col: 1), BoardLocation.init(row: 5, col: 2)])
        self.levels = [Lv1, Lv2, Lv3, Lv4]
    }
    
    public init(levels: [GameState]) {
        self.levels = levels
    }
    
    public func initBoard(with level: Int) -> GameState {
        return self.levels[level - 1]
    }
    
    public func getNumOfLevels() -> Int {
        return self.levels.count
    }
    
    public func getHighestUnlockedLevel() -> Int {
        var ret: Int = 0
        for level in self.levels {
            if level.levelPassed {
                ret += 1
            }
        }
        return ret // mark all levels to not passed when exiting the game? or write a method to reset the whole progress
    }
}
