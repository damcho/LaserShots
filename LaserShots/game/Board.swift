//
//  Board.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class Board :BoardLoaderDelegate{
    
    private var laserGunCell:BoardCell?
    private let boardLoader = LevelLoader()
    var cells: [[BoardCell]] = []
    var onGameStateChanged:((gameState) -> ())?
    var onLevelLoaded:(() -> ())?
    
    init() {
        self.boardLoader.delegate = self
    }
    
    func levelLoaded(board:[[BoardCell]], laserGun:BoardCell) {
        self.cells = board
        self.laserGunCell = laserGun
        self.onLevelLoaded?()
    }

    
    func loadBoard(name:String) {
        self.boardLoader.loadBoard(name: name, actionHandler:{ [unowned self] () -> () in
            self.clearBoard()
            self.shootLaser()
        })
    }
    
    private func clearBoard() {
        for cellsArray in self.cells {
            for cell in cellsArray {
                cell.clear()
            }
        }
    }
    
    private func getNextCellfor(direction:pointingDirection, currentCell:BoardCell) -> BoardCell? {
        switch direction {
        case .up:
            return self.cells[currentCell.i][currentCell.j - 1]
        case .down:
            return self.cells[currentCell.i ][currentCell.j + 1]
        case .left:
            return self.cells[currentCell.i - 1][currentCell.j]
        case .right:
            return self.cells[currentCell.i + 1][currentCell.j]
        case .none:
            return nil
        }
    }
    
    private func shootNext(directions:[pointingDirection], currentCell:BoardCell) {

        if currentCell.cellType == .LaserTrap {
            self.onGameStateChanged?(.gameLost)
            return
        } else if currentCell.cellType == .LaserDestination{
            self.onGameStateChanged?(.nextLevel)
            return
        }
        
        for laserDirection in directions {
            let nextCell = self.getNextCellfor(direction: laserDirection, currentCell: currentCell)
            if nextCell != nil {
                let newDirections = nextCell!.getLaserReflection(from: laserDirection)
                self.shootNext(directions: newDirections, currentCell: nextCell!)
            }
        }
    }
    
    func shootLaser() {
        guard let laserGunCell = self.laserGunCell else {
            return
        }
        let laserDirection = laserGunCell.getInitialShotDirection()
        self.shootNext(directions: [laserDirection], currentCell: laserGunCell)
    }
}
