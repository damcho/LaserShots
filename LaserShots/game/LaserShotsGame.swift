//
//  LaserShotsGame.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class LaserShotsGame  {
    let board:Board
    
    init() {
        self.board = Board("board1")
        print(self.board)
    }
}
