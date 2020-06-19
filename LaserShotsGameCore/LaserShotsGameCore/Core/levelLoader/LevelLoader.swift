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
                do {
                    let (wrapperElements, width, height) = try GameElementsMapper.map(data: data)
                    completion(.success(Board(width: width, height: height, elements: wrapperElements)))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        })
    }
}
