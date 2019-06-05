//
//  Board.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Board {
    
    private var width:Int = 0
    private var height:Int = 0
    private var laserGunCell:BoardCell?
    private let boardLevelName:String = "level"
    var levelIndex = 1
    var cells: [[BoardCell]] = []
    var onGameStateChanged:((gameState) -> ())?
    var onLevelLoaded:(() -> ())?
    var onCellTapHandler :(() -> ())?
    
    func loadLevel() {
        self.loadBoard(name: self.boardLevelName + "\(self.levelIndex)")
        self.onLevelLoaded?()
    }
    
    func loadNextLevel() {
        self.levelIndex += 1
        self.loadLevel()
    }
    
    private func createEmptyBoard() {
        self.cells = []
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
            self.cells.append(cellColumn)
        }
        
        self.onCellTapHandler = { () -> () in
            self.clearBoard()
            self.shootLaser()
        }
    }
    
    func loadBoard(name:String) {
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json") else {
            return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        
        guard let Jsonboard = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? Dictionary<String, Any> else {
            return
        }
        
        guard let width = Jsonboard["width"] as? Int else {
            return
        }
        guard let height = Jsonboard["height"] as? Int else {
            return
        }
        self.width = width
        self.height = height
        
        guard let gameElementsJsonRep = Jsonboard["gameElements"] as? Array<Dictionary<String, Any>> else {
            return
        }
        self.createEmptyBoard()
        self.populateBoard(jsonArray:gameElementsJsonRep )
    }
    
    
    private func populateBoard( jsonArray:Array<Dictionary<String, Any>>) {
        for jsonElement in jsonArray {
            let elementType = jsonElement["type"] as! String
            let x = jsonElement["x"] as! Int
            let y = jsonElement["y"] as! Int
            let gameElement:GameElement?

            switch elementType {
            case "laserGun":
                gameElement = LaserGun(jsonElement: jsonElement)
                self.laserGunCell = self.cells[x][y]
            case "laserDestination":
                gameElement = LaserDestination(jsonElement: jsonElement)
            case "Mirror":
                 self.cells[x][y].onCellTapped = self.onCellTapHandler
                gameElement = Mirror(jsonElement: jsonElement)
            case "TransparentMirror":
                self.cells[x][y].onCellTapped = self.onCellTapHandler
                gameElement = TransparentMirror(jsonElement: jsonElement)
            case "laserTrap":
                gameElement = LaserTrap()
            default:
                return
            }
            if gameElement != nil && x <= self.width+1 && y <= self.height+1 {
                self.cells[x][y].gameElement = gameElement
            }
        }
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
