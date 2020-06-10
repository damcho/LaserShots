//
//  LevelLoaderTests.swift
//  LaserShotsTests
//
//  Created by Damian Modernell on 6/10/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest

typealias loaderCompletion = (LevelLoaderResult) -> Void
typealias LevelLoaderClientCompletion = (BundleLevelLoaderResult) -> Void

struct GameElement: Equatable {}
enum LevelLoaderResult {
    case success([GameElement])
    case failure(Error)
}

enum BundleLevelLoaderResult {
    case success(Data)
    case failure(BundleLoaderError)
}

enum BundleLoaderError: Error {
    case invalidData
    case unknownError
}

protocol LevelLoaderClient {
    func loadLevel(name: String, completion: @escaping LevelLoaderClientCompletion)
}

class LevelLoader {
    
    let loaderClient: LevelLoaderClient
    init(client: LevelLoaderClient) {
        self.loaderClient = client
    }
    
    func loadBoard(name: String, completion: @escaping loaderCompletion) {
        loaderClient.loadLevel(name: name, completion: { result in
            switch result {
            case .failure:
                completion(.failure(NSError(domain: "some error", code: 1)))
            case .success(let data):
                completion(.success([]))
            }
        })
    }
}

class LevelLoaderTests: XCTestCase {
    
    func test_returnsEmptyListOnEmptyJSON() {
        let loaderClient = BundleLevelLoaderSpy()
        let sut = LevelLoader(client: loaderClient)
        
        let emptyJSON = Data("{}".utf8)
        
        let exp = expectation(description: "error received on invalid data")
        sut.loadBoard(name: "level1", completion: {result in
            switch result {
            case .success(let elements):
                XCTAssertEqual(elements, [])
            default:
                XCTFail()
            }
            exp.fulfill()
        })
        
        loaderClient.completeWithData(data: emptyJSON)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_levelLoader_reuturnsErrorOnInvalidLevelData() {
        let loaderClient = BundleLevelLoaderSpy()
        let sut = LevelLoader(client: loaderClient)
        
        let invalidLevelData = Data("invalidLevelJSON".utf8)
        
        let exp = expectation(description: "error received on invalid data")
        sut.loadBoard(name: "level1", completion: {resullt in
            switch resullt {
            case .failure(let error):
                XCTAssertNotNil(error)
            default:
                XCTFail()
            }
            exp.fulfill()
        })
        
        loaderClient.completeWithError(.invalidData)
        
        wait(for: [exp], timeout: 1.0)
    }
}

class Board {}

private class BundleLevelLoaderSpy: LevelLoaderClient {
    var messages: [(BundleLevelLoaderResult) -> Void] = []
    
    func loadLevel(name: String, completion: @escaping LevelLoaderClientCompletion) {
        messages.append(completion)
    }
    
    func completeWithError(_ error: BundleLoaderError, at index: Int = 0) {
        if !messages.isEmpty {
            messages[index](.failure(.invalidData))
        }
    }
    
    func completeWithData(data: Data, at index: Int = 0) {
        if !messages.isEmpty {
            messages[index](.success(data))
        }
    }
    
}
