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
        return BoardInfo(rowNum: 8, colNum: 6, goalLocation: BoardLocation(row: 7, col: 5),
                         obstacleLocations: [BoardLocation(row: 5, col: 4), BoardLocation(row: 5, col: 3)],
                         originLocation: BoardLocation(row: 0, col: 0))
    }
    
    func move(with direction: Direction) -> ActionType {
        return ActionType.invalid(direction)
    }
    
    
}
