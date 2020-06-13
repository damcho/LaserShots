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
    private let numberOfLevels = 2
    private let boardLevelName:String = "level"
    private var levelIndex = 0
    private var currentLevel:Board?
    weak var delegate:laserShotsDelegate?
    
    let levelLoader: LaserShotsLevelLoader
    
    init(levelLoader: LaserShotsLevelLoader) {
        self.levelLoader = levelLoader
    }
    
    func boardCells() -> [[BoardCell]] {
        guard let boardCells = self.currentLevel?.boardCells else {
            return []
        }
        return boardCells
    }
    
    func start() {
        self.currentLevel?.shootLaser()
    }
    
    func restartLevel(){
        self.loadLevel()
    }
    
    func nextLevel() {
        self.levelIndex += 1
        self.loadLevel()
    }
    
    private func loadLevel() {
        let nextLevelName = self.boardLevelName + "\(self.levelIndex)"
        self.currentLevel = Board(width: 0, height: 0, elements: [])
        self.currentLevel?.onLevelLoaded = { [unowned self] () -> () in
            self.delegate?.levelLoaded()
        }
        self.currentLevel?.onGameStateChanged = {[unowned self] (state:gameState) in
            switch state {
            case .nextLevel:
                if self.levelIndex < self.numberOfLevels {
                    self.delegate?.gameState(state: state)
                } else {
                    self.delegate?.gameState(state: .gameWon)
                }
            default:
                self.delegate?.gameState(state: state)
            }
        }
        
    //    self.currentLevel?.loadBoard(name: nextLevelName)
    }
}
