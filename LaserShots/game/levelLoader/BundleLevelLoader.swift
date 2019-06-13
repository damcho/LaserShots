//
//  BundleLevelLoader.swift
//  LaserShots
//
//  Created by Damian Modernell on 13/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class BundleLevelLoader: LaserShotsLevelLoader {
    
    func loadLevel(name:String, levelLoadedHandler:(Data) -> ()) {
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url )else {
            return
        }
        levelLoadedHandler(data)
    }
}
