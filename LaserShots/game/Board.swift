//
//  Board.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Board {
    
    var cells: [[BoardCell]] = []
    var width:Int = 0
    var height:Int = 0
    var laserGunCell:BoardCell?
    
    init(_ boardName:String) {
        self.loadBoard(name: boardName)
    }
    
    func createBoard() {
        for i in 0...width + 1 {
            var cellsRow:[BoardCell] = []
            for j in 0...height + 1 {
                let boardCell = BoardCell(i: i, j: j)
                cellsRow.append(boardCell)
                if j == height+1 || j == 0 {
                    boardCell.gameElement = Wall(direction: .down)
                }
                if i == height+1 || i == 0 {
                    boardCell.gameElement = Wall(direction: .left)
                }
            }
            self.cells.append(cellsRow)
        }
        print(self.cells)
    }
    
    func loadBoard(name:String) {
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        
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
        self.createBoard()
        self.populateBoard(jsonArray:gameElementsJsonRep )

        print(self.cells)
    }
    
    
    func populateBoard( jsonArray:Array<Dictionary<String, Any>>) {
        for jsonElement in jsonArray {
            let elementType = jsonElement["type"] as! String
            let x = jsonElement["x"] as! Int
            let y = jsonElement["y"] as! Int
            let gameElement:GameElement?
            let onCellTapHandler = { () -> () in
                self.clearBoard()
                self.shootLaser()
            }
            switch elementType {
            case "laserGun":
                gameElement = LaserGun(jsonElement: jsonElement)
                self.laserGunCell = self.cells[x][y]
            case "laserDestination":
                gameElement = LaserDestination(jsonElement: jsonElement)
            case "Mirror":
                 self.cells[x][y].onCellTapped = onCellTapHandler
                gameElement = Mirror(jsonElement: jsonElement)
            default:
                return
            }
            if gameElement != nil && x < self.width+1 && y < self.height+1 {
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
    
    
    func shootLaser() {
        guard var currentCell = self.laserGunCell else {
            return
        }
        var laserDirection = currentCell.getLaserDirection( )

        while currentCell.cellType != .Wall {
            laserDirection = currentCell.getLaserDirection(direction:laserDirection )
            var nextCell:BoardCell?
            print(currentCell)

            switch laserDirection {
            case .up:
                nextCell = self.cells[currentCell.i][currentCell.j - 1]
            case .down:
                nextCell = self.cells[currentCell.i ][currentCell.j + 1]
            case .left:
                nextCell = self.cells[currentCell.i - 1][currentCell.j]
            case .right:
                nextCell = self.cells[currentCell.i + 1][currentCell.j]
            case .none:
                return
                print("finished")
            }
            currentCell = nextCell != nil ? nextCell! : currentCell
        }
    }
}
