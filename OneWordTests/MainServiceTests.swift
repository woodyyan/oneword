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
    
    func testShouldGetTwoParaphraseComponentsGivenOnePartOfSpeech() {
        let wholeParaphrase = "n.账单；招贴；票据"
        
        let components = service.getParaphraseComponents(wholeParaphrase: wholeParaphrase)
        
        XCTAssert(components.count == 2)
        XCTAssert(components[0] == "n.")
        XCTAssert(components[1] == "账单；招贴；票据")
    }
    
    func testShouldGetFourParaphraseComponentsGivenTwoPartOfSpeech() {
        let wholeParaphrase = "a.空白的 n.空白"
        
        let components = service.getParaphraseComponents(wholeParaphrase: wholeParaphrase)
        
        XCTAssert(components.count == 4)
        XCTAssert(components[0] == "a.")
        XCTAssert(components[1] == "空白的 ")
        XCTAssert(components[2] == "n.")
        XCTAssert(components[3] == "空白")
    }
    
    func testShouldGetTwoParaphraseComponentsGivenOnePartOfSpeechWithPoints(){
        let wholeParaphrase = "vt.责备，把…归咎于"
        
        let components = service.getParaphraseComponents(wholeParaphrase: wholeParaphrase)
        
        XCTAssert(components.count == 2)
        XCTAssert(components[0] == "vt.")
        XCTAssert(components[1] == "责备，把…归咎于")
    }
    
    func testShouldGetCorrectParaphraseComponentsGivenCase1(){
        let wholeParaphrase = "vt.&vi.&n.混和"
        
        let components = service.getParaphraseComponents(wholeParaphrase: wholeParaphrase)
        
        XCTAssert(components.count == 6)
        XCTAssert(components[0] == "vt.")
        XCTAssert(components[1] == "&")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
