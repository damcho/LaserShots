//
//  TransparentMirror.swift
//  LaserShots
//
//  Created by Damian Modernell on 01/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class TransparentMirror: GameElement {
    var direction: pointingDirection
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.direction = pointingDirection(rawValue:direction) ?? .down
    }
    
    func reflect(direction: pointingDirection) -> pointingDirection {
        return .none
    }
    
    
}
