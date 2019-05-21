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
    var gameElement:GameElement?
    
    init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }
    
    var description : String {
        get {
            return "x:`\(x) `\(y) `\(gameElement)"
        }
    }
    
}
