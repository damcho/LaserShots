//
//  BundleLevelLoader.swift
//  LaserShots
//
//  Created by Damian Modernell on 12/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class LevelLoader  {
    
    var delegate:BoardLoaderDelegate?
    private var width:Int = 0
    private var height:Int = 0
    private let levelLoader:LaserShotsLevelLoader = BundleLevelLoader()
    
    func loadBoard(name: String, actionHandler: @escaping () -> () ) {

        self.levelLoader.loadLevel(name: name, levelLoadedHandler: {[unowned self] (data) ->() in
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
            let boardCells = self.createEmptyBoard()
            guard let laserGunCell = self.populateBoard(board:boardCells, elements:gameElementsJsonRep, handler:actionHandler ) else {
                return
            }
            self.delegate?.levelLoaded(board: boardCells, laserGun: laserGunCell)
        })
    }
    
    private func populateBoard(board:[[BoardCell]], elements:Array<Dictionary<String, Any>>, handler: @escaping () -> ()) -> BoardCell? {
        var laserGun:BoardCell?

        for jsonElement in elements {
            let elementType = jsonElement["type"] as! String
            let x = jsonElement["x"] as! Int
            let y = jsonElement["y"] as! Int
            let gameElement:GameElement?
            switch elementType {
            case "laserGun":
                gameElement = LaserGun(jsonElement: jsonElement)
                laserGun = board[x][y]
            case "laserDestination":
                gameElement = LaserDestination(jsonElement: jsonElement)
            case "Mirror":
                board[x][y].onCellTapped = handler
                gameElement = Mirror(jsonElement: jsonElement)
            case "TransparentMirror":
                board[x][y].onCellTapped = handler
                gameElement = TransparentMirror(jsonElement: jsonElement)
            case "laserTrap":
                gameElement = LaserTrap()
            default:
                return nil
            }
            if gameElement != nil && x <= self.width+1 && y <= self.height+1 {
                board[x][y].gameElement = gameElement
            }
        }
        return laserGun
    }
    
    
    private func createEmptyBoard() -> [[BoardCell]] {
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
        return boardCells
    }
}
