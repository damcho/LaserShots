//
//  Mirror.swift
//  NavalWars
//
//  Created by Damian Modernell on 21/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Mirror: GameElement, Flipable, Reflectable {

    var hasLaserBeam: Bool
    var direction: flipDirection
    
    init?(jsonElement:Dictionary<String, Any>) {
        
        guard let direction = jsonElement["direction"] as? String else {
            return nil
        }
        self.hasLaserBeam = false
        self.direction = flipDirection(rawValue:direction) ?? .down
    }
    
    func flip()  {
        
        
    }
    
    func reflect() -> flipDirection{
        return .down
    }
    
    

  
    
    
}
