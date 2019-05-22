//
//  BoardCell.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class BoardCell:CustomStringConvertible {
    
    let x:Int
    let y:Int
    var gameElement:GameElement? {
        didSet {
            self.setCellType()
        }
        
    }
    var cellType:cellType = .Empty
    
    init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }
    
    func setCellType() {
        if self.gameElement is LaserGun {
            cellType = .LaserGun
        } else if self.gameElement is LaserDestination {
            cellType = .LaserDestination
        } else if self.gameElement is Mirror {
            cellType = .Mirror
        } else {
            cellType = .Empty
        }
    }
    
    func rotation() -> Double{
        guard let gameElement = self.gameElement else {
            return 0
        }
        switch gameElement.direction {
        case .left:
            return .pi/2
        case .right:
            return .pi * 3/2
        case .up:
            return .pi
        case .down:
            return 0
        }
    }
    
    var description : String {
        get {
            return "x:`\(x) `\(y) `\(gameElement)"
        }
    }
    
}
