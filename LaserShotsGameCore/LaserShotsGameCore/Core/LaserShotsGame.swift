//
//  LaserShotsGame.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public enum GameState {
    case gameWon
    case gameLost
    case nextLevel
}

public class LaserShotsGame  {
    private let numberOfLevels = 2
    private let boardLevelName: String = "level"
    private var levelIndex = 0
    private var currentLevelBoard: Board?
    private let levelLoader: LaserShotsLevelLoader

    weak var delegate: laserShotsDelegate?
    
    
    public init(levelLoader: LaserShotsLevelLoader) {
        self.levelLoader = levelLoader
    }
    
    func start() {
        self.currentLevelBoard?.shootLaser()
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
        self.levelLoader.loadBoard(name: nextLevelName) { (result) in
            
            switch result {
            case .failure:
                break
            case .success(let levelBoard):
                self.currentLevelBoard = levelBoard
                
                self.currentLevelBoard?.onGameStateChanged = {[unowned self] (state:GameState) in
                    switch state {
                    case .nextLevel:
                        if self.levelIndex < self.numberOfLevels {
                            self.delegate?.gameStateChanged(state: state)
                        } else {
                            self.delegate?.gameStateChanged(state: .gameWon)
                        }
                    default:
                        self.delegate?.gameStateChanged(state: state)
                    }
                }
                self.delegate?.levelLoaded(with: self.currentLevelBoard?.boardCells ?? [])
            }
        }
    }
}
