//
//  LevelLoaderTests.swift
//  LaserShotsTests
//
//  Created by Damian Modernell on 6/10/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import LaserShots

typealias loaderCompletion = (LevelLoaderResult) -> Void
typealias LevelLoaderClientCompletion = (BundleLevelLoaderResult) -> Void

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

class GameElementsMapper {
    static func map(elements: [CodableGameElement]) -> [GameElement] {
        return elements.compactMap { (codableElement) in
            guard let elementDirection = pointingDirection(rawValue: codableElement.direction),
                let elementType = cellType(rawValue: codableElement.type) else {
                    return nil
            }
            
            switch elementType {
            case .LaserGun:
                return LaserGun(direction: elementDirection)
            case .LaserDestination:
                return LaserDestination(direction: elementDirection)
            case .LaserTrap:
                return LaserTrap()
            case .Mirror:
                return Mirror(direction: elementDirection)
            case .TransparentMirror:
                return TransparentMirror(direction: elementDirection)
            default:
                return nil
            }
        }
        
    }
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
                guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
                    completion(.failure(NSError(domain: "invalid data", code: 1)))
                    return
                }
                let gameElements = GameElementsMapper.map(elements: root.gameElements)
                completion(.success(gameElements))
            }
        })
    }
}

class LevelLoaderTests: XCTestCase {
    
    func test_levelLoader_reuturnsErrorOnLevelLoaderError() {
        let (sut, loaderClient) = makeSUT()
        
        expectErrorFor(sut: sut, when: {
            loaderClient.completeWithError(.unknownError)
        })
    }
    
    func test_returnsInvalidDataErrorOnInvalidJSONLevel() {
        let (sut, loaderClient) = makeSUT()
        
        expectErrorFor(sut: sut, when: {
            let invalidLevelData = Data("invalidLevelJSON".utf8)
            loaderClient.completeWithData(data: invalidLevelData)
        })
    }
    
    func test_returnsEmptyListOnEmptyGameElementsJSONLevel() {
        let (sut, loaderClient) = makeSUT()
        
        expectSuccessFor(sut: sut, toCompleteWith: [], when: {
            let emptyGameElementsLevel = ["width": 2, "height": 2, "gameElements":[]] as [String : Any]
            let levelData = try! JSONSerialization.data(withJSONObject: emptyGameElementsLevel)
            loaderClient.completeWithData(data: levelData)
        })
    }
    
    func test_returnsValidGameElementsOnlyWhenJSONContainsInvalidElement() {
        let (sut, loaderClient) = makeSUT()
        let (laserGun1, laserJSON1) = makeGameElement("LaserGun", xPos: 0, yPos: 0, pointing: "down")
        let invalidLaserGun2JSON = ["type": "LaserGun", "x": 1, "y": 1,"direction": "wrong direction"] as [String : Any]
        let levelWithInvalidGameElement = ["width": 2, "height": 2, "gameElements":[laserJSON1, invalidLaserGun2JSON]] as [String : Any]
        let levelData = try! JSONSerialization.data(withJSONObject: levelWithInvalidGameElement)

        expectSuccessFor(sut: sut, toCompleteWith: [laserGun1], when: {
            loaderClient.completeWithData(data: levelData)
        })
    }
    
    func test_returnsArrayOfGameElementsOnValidJSONLevel() {
        let (sut, loaderClient) = makeSUT()
        let (laserGun1, laserJSON1) = makeGameElement("LaserGun", xPos: 0, yPos: 0, pointing: "down")
        let (mirror1, mirrorJSON1) = makeGameElement("Mirror", xPos: 1, yPos: 1, pointing: "left")
        
        let levelJSON = ["width": 2, "height": 2, "gameElements":[laserJSON1, mirrorJSON1]] as [String : Any]
        let levelData = try! JSONSerialization.data(withJSONObject: levelJSON)
        
        expectSuccessFor(sut: sut, toCompleteWith: [laserGun1, mirror1], when: {
            loaderClient.completeWithData(data: levelData)
        })
    }
    
    
    //Helpers
    private func makeSUT() -> (LevelLoader, BundleLevelLoaderSpy) {
        let loaderClient = BundleLevelLoaderSpy()
        let sut = LevelLoader(client: loaderClient)
        return (sut, loaderClient)
    }
    
    private func makeGameElement(_ type: String, xPos: Int, yPos: Int, pointing: String) -> (GameElement, [String: Any]) {
        let gameElementJSON = ["type": type, "x": xPos, "y": yPos,"direction": pointing] as [String : Any]
        
        let elementDirection = pointingDirection(rawValue: pointing)!
        let elementType = cellType(rawValue: type)!
        let gameElement: GameElement
        switch elementType {
        case .LaserGun:
            gameElement = LaserGun(direction: elementDirection)
        case .LaserDestination:
            gameElement = LaserDestination(direction: elementDirection)
        case .LaserTrap:
            gameElement = LaserTrap()
        case .Mirror:
            gameElement = Mirror(direction: elementDirection)
        case .TransparentMirror:
            gameElement = TransparentMirror(direction: elementDirection)
        default:
            gameElement = LaserGun(direction: elementDirection)
        }
        return (gameElement, gameElementJSON)
    }
    
    private func expectErrorFor(sut: LevelLoader, when action: () -> Void , file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "expect received error")
        
        sut.loadBoard(name: "level1", completion: {resullt in
            switch resullt {
            case .failure(let error):
                XCTAssertNotNil(error, file: file, line: line)
            default:
                XCTFail("expected failure but got success instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expectSuccessFor(sut: LevelLoader, toCompleteWith expectedElements: [GameElement], when action: () -> Void , file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "expect results")
        
        sut.loadBoard(name: "level1", completion: {result in
            switch result {
            case .success(let receivedElements):
                XCTAssertEqual(expectedElements.count, receivedElements.count, file: file, line: line)
                receivedElements.enumerated().forEach { (index, receivedElement) in
                    XCTAssertEqual(receivedElement.direction, expectedElements[index].direction, file: file, line: line)
                }
            default:
                XCTFail("expected success but got failure instead", file: file, line: line)
            }
            exp.fulfill()
        })
        
        action()
        
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
