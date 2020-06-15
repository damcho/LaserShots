//
//  LaserGameViewModel.swift
//  LaserShots
//
//  Created by Damian Modernell on 6/15/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class LaserGameViewModel {
    
    struct AlertViewModel {
        let titleText: String
        let actionTitleTText: String
        let alertMsgText: String
        let state: GameState
    }
    
    private let laserShotsGame: LaserShotsGame
    var onBoardLoaded: (([CellViewModel], Int) -> Void)?
    var onGameStateChanged: ((AlertViewModel) -> Void)?
    
    init(laserShotsGame: LaserShotsGame) {
        self.laserShotsGame = laserShotsGame
        self.laserShotsGame.delegate = self
    }
    
    func start() {
        self.laserShotsGame.start()
    }
    
    func nextLevel() {
        self.laserShotsGame.nextLevel()
    }
    
    func restartLevel(){
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
