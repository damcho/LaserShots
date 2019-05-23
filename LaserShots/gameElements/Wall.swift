//
//  Wall.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Wall: GameElement {
    var direction: pointingDirection
    
    func reflect() -> pointingDirection {
        return .none
    }
    
    init(direction:pointingDirection) {
        self.direction = direction
    }
}
