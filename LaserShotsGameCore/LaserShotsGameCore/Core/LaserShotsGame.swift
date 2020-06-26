//
//  LaserShotsGame.swift
//  LaserShots
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

protocol laserShotsDelegate: class {
    func gameStateChanged(state: GameState)
    func levelLoaded(with boardCells: [[BoardCell]])
}

public enum GameState {
    case gameWon
    case gameLost
    case nextLevel
}

public enum PointingDirection: String {
    case up
    case down
    case left
    case right
    case none
}

public class LaserShotsGame  {
    var levelNames: [String]
    private var levelIndex = 0
    private var currentLevelBoard: Board?
    private let levelLoader: LaserShotsLevelLoader
    
    weak var delegate: laserShotsDelegate?
    
    public init(levelLoader: LaserShotsLevelLoader, levelNames: [String]) {
        self.levelLoader = levelLoader
        self.levelNames = levelNames
    }
    
    func start() {
        self.currentLevelBoard?.shootLaser()
    }
    
    func loadLevel() {
        self.loadBoard()
    }
    
    private func boardLoadedWithSuccess(_ board: Board) {
        self.currentLevelBoard = board
        self.currentLevelBoard?.onLevelStateChanged = {[unowned self] (state) in
            switch state {
            case .levelPassed:
                self.levelIndex += 1
                self.levelIndex < self.levelNames.count ?
                    self.delegate?.gameStateChanged(state: .nextLevel) :
                    self.delegate?.gameStateChanged(state: .gameWon)
            default:
                self.delegate?.gameStateChanged(state: .gameLost)
            }
        }
        self.delegate?.levelLoaded(with: self.currentLevelBoard?.boardCells ?? [])
    }
    
    private func loadBoard() {
        if levelIndex < levelNames.count {
            let nextLevelName = self.levelNames[levelIndex]
            self.levelLoader.loadBoard(name: nextLevelName) { (result) in
                switch result {
                case .failure:
                    break
                case .success(let levelBoard):
                    self.boardLoadedWithSuccess(levelBoard)
                }
            }
        }
    }
}
