//
//  Board.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class Board: BoardLoaderDelegate{
    
    private var laserGunCell:BoardCell?
    var boardCells: [[BoardCell]] = []
    var onGameStateChanged:((gameState) -> ())?
    var onLevelLoaded:(() -> ())?
    
    private let width: Int
    private let height: Int
    private let gameElements: [GameElement]
    
    public init(width: Int, height: Int, elements: [GameElement]) {
        self.width = width
        self.height = height
        self.gameElements = elements
        
        self.createEmptyBoard()
        self.populateBoard()
    }
    
    
    private func createEmptyBoard() {
        var boardCells:[[BoardCell]] = []
        for i in 0...width + 1 {
            var cellColumn:[BoardCell] = []
            for j in 0...height + 1 {
                let boardCell = BoardCell(i: i, j: j)
                cellColumn.append(boardCell)
                if j == height+1 ||
                    j == 0 ||
                    i == height+1 ||
                    i == 0{
                    boardCell.gameElement = Wall()
                }
            }
            boardCells.append(cellColumn)
        }
        self.boardCells = boardCells
    }
    
    private func populateBoard() -> BoardCell? {
        var laserGun:BoardCell?
        
        for gameElement in gameElements {
            if gameElement.x <= self.width+1 && gameElement.y <= self.height+1 {
                boardCells[gameElement.x][gameElement.y].gameElement = gameElement
            }
        }
        return laserGun
    }
    
    
    func levelLoaded(board:[[BoardCell]], laserGun:BoardCell) {
        self.boardCells = board
        self.laserGunCell = laserGun
        self.onLevelLoaded?()
    }
    
    

    
    private func clearBoard() {
        for cellsArray in self.boardCells {
            for cell in cellsArray {
                cell.clear()
            }
        }
    }
    
    private func getNextCellfor(direction:pointingDirection, currentCell:BoardCell) -> BoardCell? {
        switch direction {
        case .up:
            return self.boardCells[currentCell.i][currentCell.j - 1]
        case .down:
            return self.boardCells[currentCell.i ][currentCell.j + 1]
        case .left:
            return self.boardCells[currentCell.i - 1][currentCell.j]
        case .right:
            return self.boardCells[currentCell.i + 1][currentCell.j]
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
