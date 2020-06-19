//
//  LaserGameViewModel.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/15/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public final class LaserGameViewModel {
    
    public struct AlertViewModel {
        public let titleText: String
        public let actionTitleTText: String
        public let alertMsgText: String
        public let state: GameState
    }
    
    private let laserShotsGame: LaserShotsGame
    public var onBoardLoaded: (([CellViewModel], Int) -> Void)?
    public var onGameStateChanged: ((AlertViewModel) -> Void)?
    
    public init(laserShotsGame: LaserShotsGame) {
        self.laserShotsGame = laserShotsGame
        self.laserShotsGame.delegate = self
    }
    
    public func start() {
        self.laserShotsGame.start()
    }
    
    public func nextLevel() {
        self.laserShotsGame.nextLevel()
    }
    
    public func restartLevel(){
        self.laserShotsGame.restartLevel()
    }
    
    private func createBoardGame(with cells: [[BoardCell]]) -> [CellViewModel] {
        var cellViewModelsArray: [CellViewModel] = []
        for cellsArray in cells {
            for cell in cellsArray {
                cellViewModelsArray.append(CellViewModel(boardCell: cell))
            }
        }
        return cellViewModelsArray
    }
}

extension LaserGameViewModel: laserShotsDelegate {
    
    func gameStateChanged(state: GameState) {
        var title:String
        var actionTitle:String
        var msg:String
        switch state {
        case .nextLevel:
            actionTitle = "next level"
            msg = "YEAHH"
            title = "You passed to the next level"
        case .gameWon:
            actionTitle = "Main screen"
            msg = "YEAHH"
            title = "You Finished all the levels"
        case .gameLost:
            actionTitle = "Restart level"
            msg = "You lost"
            title = "Ups"
        }
        let alertViewModel = AlertViewModel(titleText: title, actionTitleTText: actionTitle, alertMsgText: msg, state: state)
        self.onGameStateChanged?(alertViewModel)
    }
    
    func levelLoaded(with boardCells: [[BoardCell]]) {
        let cellsViewModels = createBoardGame(with: boardCells)
        let cellsPerRow = boardCells.isEmpty ? 0 : boardCells[0].count
        self.onBoardLoaded?(cellsViewModels, cellsPerRow)
    }
}
