//
//  Streamline.swift
//  Streamline
//
//  Created by Chongbin (Bob) Zhang on 2019/7/31.
//  Edited by Chongbin (Bob) Zhang & Xuezheng Wang
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation
import UIKit

class Streamline: AppDelegate, GameLogicDelegate {
    
    var levels: [GameState]
    var currentLv: Int
    
    // get given level, first check if that level is passed, if so return that level
    // if not, check if it's smaller than the current highest passed level, if so return that level
    // if not, return the current unlocked highest level
    func getLevel(with level: Int) -> BoardInfo {
        if self.levels[level].levelPassed {
            return self.levels[level].board
        }
        else if level <= self.currentLv {
            return self.levels[level].board
        }
        else {
            return self.levels[currentLv].board
        }
    }
    
    // called when the current level is passed and player is moving on to next level
    func getNextLevelBoard() -> BoardInfo {
        currentLv += 1
        print(currentLv)
        if self.currentLv >= self.levels.count {
            fatalError("All levels exploited")
        }
        return levels[currentLv].board
    }
    
    func move(with direction: Direction) -> ActionType {
        return levels[currentLv].move(with: direction)
    }
    
    // with 8 sample levels: more on remote... I'm lazy hard-coding them as of now... there's also some complicated levels
    // TODO: find a way to read from files and save the games
    public override init() {
        let Lv1 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 1, col: 3), BoardLocation.init(row: 3, col: 2), BoardLocation.init(row: 4, col: 2)])
        let Lv2 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 0, col: 2), BoardLocation.init(row: 2, col: 3), BoardLocation.init(row: 5, col: 4)])
        let Lv3 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 0, col: 1), BoardLocation.init(row: 2, col: 4), BoardLocation.init(row: 3, col: 1)])
        let Lv4 = GameState.init(height: 6, width: 5, playerRow: 5, playerCol: 0, goalRow: 0, goalCol: 4, obstLocations: [BoardLocation.init(row: 1, col: 4), BoardLocation.init(row: 2, col: 0), BoardLocation.init(row: 2, col: 2), BoardLocation.init(row: 3, col: 3), BoardLocation.init(row: 4, col: 1), BoardLocation.init(row: 5, col: 2)])
        self.levels = [Lv1, Lv2, Lv3, Lv4]
        self.currentLv = 0
    }
    
    public func getGoalLocation() -> BoardLocation {
        return self.levels[currentLv].board.goalLocation
    }
    
    public init(levels: [GameState]) {
        self.levels = levels
        self.currentLv = -1
    }
    
    public func getCurrentLevel() -> GameState {
        return self.levels[getHighestUnlockedLevel()]
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
        return ret
    }
    
    // mark all levels to not played
    public func resetProgress() {
        for level in self.levels {
            level.levelPassed = false
        }
        self.currentLv = 0
    }
    
    // upon launch, clear all previous progress
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.resetProgress()
        return true
    }
}
