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
    
    init(_ boardName:String) {
        self.loadBoard(name: boardName)
    }
    
    func createBoard(size:Int) {
        for i in 0..<size {
            var cellsRow:[BoardCell] = []
            for j in 0..<size {
                let boardCell = BoardCell(x: i, y: j)
                cellsRow.append(boardCell)
            }
            self.cells.append(cellsRow)
        }
    }
    
    func loadBoard(name:String) {
        let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        
        guard let Jsonboard = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? Dictionary<String, Any> else {
            return
        }
        
        guard let size = Jsonboard["size"] as? Int else {
            return
        }
        guard let gameElementsJsonRep = Jsonboard["gameElements"] as? Array<Dictionary<String, Any>> else {
            return
        }
        self.createBoard(size: size)
        self.populateBoard(jsonArray:gameElementsJsonRep, boardSize:size)

        print(self.cells)
    }
    
    
    func populateBoard( jsonArray:Array<Dictionary<String, Any>>, boardSize:Int) {
        for jsonElement in jsonArray {
            let elementType = jsonElement["type"] as! String
            let x = jsonElement["x"] as! Int
            let y = jsonElement["y"] as! Int
            let gameElement:GameElement?
            switch elementType {
            case "laserGun":
                gameElement = LaserGun(jsonElement: jsonElement)
                
            case "laserDestination":
                gameElement = LaserDestination(jsonElement: jsonElement)
                
            case "Mirror":
                gameElement = Mirror(jsonElement: jsonElement)

            default:
                return
            }
            if gameElement != nil && x < boardSize && y < boardSize {
                self.cells[x][y].gameElement = gameElement
            }
        }
    }
}