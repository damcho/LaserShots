//
//  GameElementsMapper.swift
//  LaserShotsGameCore
//
//  Created by Damian Modernell on 6/20/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class GameElementsMapper {
    struct CodableGameElement: Codable {
         let x: Int
         let y: Int
         let direction: String?
         let type: String
     }

     struct Root: Codable {
         let width: Int
         let height: Int
         let gameElements: [CodableGameElement]
     }
    
    static func map(data: Data) throws -> ([GameElementWrapper], Int, Int) {
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw NSError(domain: "Invalid data", code: 1)
        }
           
        let gameElements: [GameElementWrapper] = root.gameElements.compactMap { (codableElement) in
            var elementDirection: PointingDirection?
            guard let elementType = CellType(rawValue: codableElement.type) else {
                return nil
            }
            if let elementDir = codableElement.direction {
                elementDirection = PointingDirection(rawValue: elementDir)
            }
            
            guard let gameElement = GameElementsMapper.makeGaneElement(elementType: elementType, elementDirection: elementDirection) else {
                return nil
            }
            return GameElementWrapper(x: codableElement.x, y: codableElement.y, gameElement: gameElement)
        }
        return (gameElements, root.width, root.height)
    }
    
    private static func makeGaneElement(elementType: CellType, elementDirection: PointingDirection?) -> GameElement? {
        switch elementType {
        case .laserGun:
            return LaserGun(direction: elementDirection ?? .none)
        case .laserDestination:
            return LaserDestination(direction: elementDirection ?? .none)
        case .laserTrap:
            return LaserTrap()
        case .mirror:
            return Mirror(direction: elementDirection ?? .none)
        case .transparentMirror:
            return TransparentMirror(direction: elementDirection ?? .none)
        default:
            return nil
        }
    }
}
