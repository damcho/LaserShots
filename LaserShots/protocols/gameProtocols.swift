//
//  gameProtocols.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

enum flipDirection:String {
    case up
    case down
    case left
    case right
}

protocol GameElement {
    var direction: flipDirection { get }
    var hasLaserBeam:Bool { get set }
    
}

protocol Reflectable {
    func reflect() -> flipDirection
}

extension GameElement {
    var isFlipable: Bool { return self is Flipable }
}

protocol Flipable {
    func flip() -> ()
}


