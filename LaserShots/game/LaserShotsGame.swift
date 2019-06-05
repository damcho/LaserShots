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
    case nextLevel
}

class LaserShotsGame  {
    let numberOfLevels = 2
    let currentLevel:Board
    weak var delegate:laserShotsDelegate?
    
    init() {
        self.currentLevel = Board()
        self.currentLevel.onGameStateChanged = {[unowned self] (state:gameState) in
            switch state {
            case .nextLevel:
                if self.currentLevel.levelIndex < self.numberOfLevels {
                    self.delegate?.gameState(state: state)
                } else {
                    self.delegate?.gameState(state: .gameWon)
                }
            default:
                self.delegate?.gameState(state: state)
            }
        }
        
        self.currentLevel.onLevelLoaded = { [unowned self] () -> () in
            self.delegate?.levelLoaded()
        }
        self.currentLevel.loadLevel()
    }
    
    func boardCells() -> [[BoardCell]] {
        return self.currentLevel.cells
    }
    
    func start() {
        self.currentLevel.shootLaser()
    }
    
    func restart(){
        self.currentLevel.loadLevel()
    }
    
    func nextLevel() {
        self.currentLevel.loadNextLevel()
    }
}
