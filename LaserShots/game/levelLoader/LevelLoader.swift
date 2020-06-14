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
    case success(Board)
    case failure(Error)
}

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

public struct GameElementWrapper {
    let x: Int
    let y: Int
    let gameElement: GameElement
    
    public init(x: Int, y: Int, gameElement: GameElement) {
        self.x = x
        self.y = y
        self.gameElement = gameElement
    }
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
                let gameElementsWrappers = GameElementsMapper.map(elements: root.gameElements)
                let levelBoard = Board(width: root.width, height: root.height, elements: gameElementsWrappers)
                completion(.success(levelBoard))
            }
        })
    }
}

final class GameElementsMapper {
    static func map(elements: [CodableGameElement]) -> [GameElementWrapper] {
        return elements.compactMap { (codableElement) in
            var elementDirection: PointingDirection?
            guard let elementType = CellType(rawValue: codableElement.type) else {
                return nil
            }
            if let elementDir = codableElement.direction {
                elementDirection = PointingDirection(rawValue: elementDir)
            }
            switch elementType {
            case .laserGun:
                return GameElementWrapper(x: codableElement.x, y: codableElement.y, gameElement: LaserGun(direction: elementDirection ?? .none))
            case .laserDestination:
                return GameElementWrapper(x: codableElement.x, y: codableElement.y, gameElement: LaserDestination(direction: elementDirection ?? .none))
            case .laserTrap:
                return GameElementWrapper(x: codableElement.x, y: codableElement.y, gameElement: LaserTrap())
            case .mirror:
                return GameElementWrapper(x: codableElement.x, y: codableElement.y, gameElement: Mirror(direction: elementDirection ?? .none))
            case .transparentMirror:
                return GameElementWrapper(x: codableElement.x, y: codableElement.y,gameElement: TransparentMirror(direction: elementDirection ?? .none))
            default:
                return nil
            }
        }
    }
}
