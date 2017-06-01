//
//  MainServiceTests.swift
//  OneWord
//
//  Created by Songbai Yan on 01/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import XCTest
@testable import OneWord

class MainTests: XCTestCase {
    let service = MainService()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldGetCorrectWordByRandomNumber() {
        let word = service.getRandomWord()
        
        XCTAssert(word.text.characters.count > 0)
        XCTAssert(word.paraphrase.characters.count > 0)
        XCTAssert(word.soundmark.characters.count > 0)
        XCTAssert(word.soundmark.contains("/"))
        XCTAssert(word.partOfSpeech.contains("."))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
