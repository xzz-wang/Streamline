//
//  TempGameDelegate.swift
//  Streamline
//
//  Created by Xuezheng Wang on 8/14/19.
//  Copyright © 2019 Xuezheng Wang. All rights reserved.
//

import Foundation

class tempGameDelegate: GameLogicDelegate {
    
    func getBoard() -> BoardInfo {
        return BoardInfo(rowNum: 8, colNum: 8, goalLocation: BoardLocation(row: 7, col: 7),
                         obstacleLocations: [BoardLocation(row: 5, col: 5), BoardLocation(row: 5, col: 6)],
                         originLocation: BoardLocation(row: 0, col: 0))
    }
    
    func move(with direction: Direction) -> ActionType {
        return ActionType.invalid(direction)
    }
    
    
}
