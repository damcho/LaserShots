//
//  BundleLevelLoaderTests.swift
//  LaserShotsGameCoreTests
//
//  Created by Damian Modernell on 6/25/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import LaserShotsGameCore

class BundleLevelLoaderTests: XCTestCase {
    
    func test_deliversErrorOnInvalidPath() {
        let (sut, _) = makeSUT()
        
        expectResult(.failure(.invalidPath), for: sut, fileName: "invalidFileName", when: {})
    }
    
    func test_validDataOnValidPath() {
        let (sut, _) = makeSUT()
        let expectedData: Data = "test data\n".data(using: .utf8)!
        expectResult(.success( expectedData), for: sut, fileName: "testData", when: {})
    }
    
    //Helpers
    private func makeSUT() -> (LevelLoaderClient, Bundle)  {
        let bundle = Bundle(for: type(of: self))
        return (BundleJSONLevelLoaderClient(bundle: bundle), bundle)
    }
    

    private func expectResult(_ expectedResult: BundleLevelLoaderResult, for loader: LevelLoaderClient, fileName: String, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        action()
        
        loader.loadLevel(name: fileName) { (BundleLevelLoaderResult) in
            switch (BundleLevelLoaderResult, expectedResult) {
                case (.failure(let error), .failure( let expectedError)):
                    XCTAssertEqual(error, expectedError, file: file, line: line)
                case (.success(let data), .success( let expectedData)):
                    XCTAssertEqual(data, expectedData, file: file, line: line)
                default:
                    XCTFail("error", file: file, line: line)
            }
        }
    }
}
