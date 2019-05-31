//
//  gameProtocols.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


enum cellType {
    case LaserGun
    case LaserDestination
    case Empty
    case Mirror
    case Wall
}

enum pointingDirection:String {
    case up
    case down
    case left
    case right
    case none
}

protocol laserShotsDelegate {
    func gameState(state:gameState) ->()
}

protocol GameElement {
    var direction: pointingDirection { get }
    func reflect(direction: pointingDirection) -> pointingDirection 
}

extension GameElement {
    var isFlipable: Bool { return self is Flipable }
}

protocol Flipable {
    func flip() -> ()
}


