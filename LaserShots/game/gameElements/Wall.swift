//
//  Wall.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Wall: GameElement {
    var x: Int = -1
    var y: Int = -1
    var direction: pointingDirection = .none
    
    func reflect(direction: pointingDirection) -> [pointingDirection] {
        return [self.direction]
    }
}
