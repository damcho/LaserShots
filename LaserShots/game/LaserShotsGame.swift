//
//  LaserShotsGame.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

enum gameState {
    case gameWon
    case gameLost
    case playing
}

class LaserShotsGame  {
    let board:Board
    var delegate:laserShotsDelegate?
    
    init() {
        self.board = Board("board1")
        self.board.onUserPlayed = { (state:gameState) in
            self.delegate?.gameState(state: state)
        }
    }
    
    func boardSize() -> (Int, Int) {
        return (self.board.width, self.board.height)
    }
    
    func boardCells() -> [[BoardCell]] {
        return self.board.cells
    }
    
    func start() {
        self.board.shootLaser()
    }
}
