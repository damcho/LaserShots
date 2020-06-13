//
//  BundleLevelLoader.swift
//  LaserShots
//
//  Created by Damian Modernell on 12/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public typealias loaderCompletion = (LevelLoaderResult) -> Void

public enum LevelLoaderResult {
    case success([GameElement])
    case failure(Error)
}

struct CodableGameElement: Codable {
    let x: Int
    let y: Int
    let direction: String
    let type: String
}

struct Root: Codable {
    let width: Int
    let height: Int
    let gameElements: [CodableGameElement]
}

public protocol LaserShotsLevelLoader {
    func loadBoard(name: String, completion: @escaping loaderCompletion)
}

public final class LevelLoader: LaserShotsLevelLoader  {
    private let loaderClient: LevelLoaderClient
    
    public init(client: LevelLoaderClient) {
        self.loaderClient = client
    }
    
    public func loadBoard(name: String, completion: @escaping loaderCompletion) {
        loaderClient.loadLevel(name: name, completion: { result in
            switch result {
            case .failure:
                completion(.failure(NSError(domain: "some error", code: 1)))
            case .success(let data):
                guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
                    completion(.failure(NSError(domain: "invalid data", code: 1)))
                    return
                }
                let gameElements = GameElementsMapper.map(elements: root.gameElements)
                let levelBoard = Board(width: root.width, height: root.height, elements: gameElements)
                completion(.success(gameElements))
            }
        })
    }
}

class GameElementsMapper {
    static func map(elements: [CodableGameElement]) -> [GameElement] {
        return elements.compactMap { (codableElement) in
            guard let elementDirection = PointingDirection(rawValue: codableElement.direction),
                let elementType = CellType(rawValue: codableElement.type) else {
                    return nil
            }
            
            switch elementType {
            case .LaserGun:
                return LaserGun(direction: elementDirection, x: codableElement.x, y: codableElement.y)
            case .LaserDestination:
                return LaserDestination(direction: elementDirection, x: codableElement.x, y: codableElement.y)
            case .LaserTrap:
                return LaserTrap(x: codableElement.x, y: codableElement.y)
            case .Mirror:
                return Mirror(direction: elementDirection, x: codableElement.x, y: codableElement.y)
            case .TransparentMirror:
                return TransparentMirror(direction: elementDirection, x: codableElement.x, y: codableElement.y)
            default:
                return nil
            }
        }
    }
}
