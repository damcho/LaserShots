//
//  Board.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public final class Board {
    
    var laserGunCell: BoardCell?
    public var boardCells: [[BoardCell]] = []
    var onGameStateChanged: ((GameState) -> ())?
    
    private let width: Int
    private let height: Int
    
    public init?(width: Int, height: Int, elements: [GameElementWrapper]) {
        guard width > 0, height > 0 else { return nil }
        self.width = width
        self.height = height
        
        self.createEmptyBoard()
        self.populateBoard(elements: elements)
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
    
    private func populateBoard(elements: [GameElementWrapper]) {
        
        for gameElementWrapper in elements {
            let boardCell = boardCells[gameElementWrapper.x][gameElementWrapper.y]
            if gameElementWrapper.x <= self.width+1 && gameElementWrapper.y <= self.height+1 {
                boardCell.gameElement = gameElementWrapper.gameElement
                boardCell.onCellAction = { [weak self] in
                    self?.clearBoard()
                    self?.shootLaser()
                }
            }
            if gameElementWrapper.gameElement is Shooter {
                laserGunCell = boardCell
            }
        }
    }

    private func clearBoard() {
        for cellsArray in self.boardCells {
            for cell in cellsArray {
                cell.clear()
            }
        }
    }
    
    private func getNextCellHitBy(_ laser: Laser, currentCell:BoardCell) -> BoardCell? {
        switch laser.direction {
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
    
    private func shoot(_ laserBeams: [Laser], for currentCell: BoardCell) {
        
        if currentCell.gameElement is GameTrap {
            self.onGameStateChanged?(.gameLost)
            return
        } else if currentCell.gameElement is GameDestination {
            self.onGameStateChanged?(.nextLevel)
            return
        }
        
        for laser in laserBeams {
            let nextCell = self.getNextCellHitBy(laser, currentCell: currentCell)
            if nextCell != nil {
                let reflectedLasers = nextCell!.reflect(laser)
                self.shoot(reflectedLasers, for: nextCell!)
            }
        }
    }
    
    func shootLaser() {
        guard let laserGunCell = self.laserGunCell,
            let initialLaserBeam =  laserGunCell.getInitialLaser()  else {
            return
        }
        self.shoot([initialLaserBeam], for: laserGunCell)
    }
}
