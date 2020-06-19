//
//  BundleLevelLoader.swift
//  LaserShots
//
//  Created by Damian Modernell on 13/06/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

public typealias LevelLoaderClientCompletion = (BundleLevelLoaderResult) -> Void

public protocol LevelLoaderClient {
    func loadLevel(name: String, completion: @escaping LevelLoaderClientCompletion)
}

public enum BundleLevelLoaderResult {
    case success(Data)
    case failure(BundleLoaderError)
}

public enum BundleLoaderError: Error {
    case invalidData
    case unknownError
    case invalidPath
}

public final class BundleLevelLoaderClient: LevelLoaderClient {
    
    public init() {}
    
    public func loadLevel(name:String, completion: LevelLoaderClientCompletion) {
        guard let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json") else {
            completion(.failure(.invalidPath))
            return
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url ) else {
            completion(.failure(.invalidData))
            return
        }
        completion(.success(data))
    }
}
