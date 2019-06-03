//
//  SvrfViewportExtensionTests.swift
//  GLTFSceneKitTests
//
//  Created by Jesse Boyes on 6/3/19.
//  Copyright © 2019 DarkHorse. All rights reserved.
//

import XCTest

class SvrfViewportExtensionTests: XCTestCase {

    func testParseHorizontalAlignment_simple() {
        let (align, percent) = SvrfViewportBindingExtension
            .parseHorizontalAlignment("center")
        XCTAssertEqual(align, .center)
        XCTAssertEqual(percent, 0)
        
    }
    
    func testParseHorizontalAlignment_positiveOffset() {
        let (align2, percent2) = SvrfViewportBindingExtension
            .parseHorizontalAlignment("Left + 10%")
        XCTAssertEqual(align2, .left)
        XCTAssertEqual(percent2, CGFloat(0.10))
    }
    
    func testParseHorizontalAlignment_negativeOffset() {
        let (align3, percent3) = SvrfViewportBindingExtension
            .parseHorizontalAlignment("right-50%")
        XCTAssertEqual(align3, .right)
        XCTAssertEqual(percent3, CGFloat(-0.50))
    }
    
    func testParseVerticalAlignment_simple() {
        let (align, percent) = SvrfViewportBindingExtension
            .parseVerticalAlignment("top")
        XCTAssertEqual(align, .top)
        XCTAssertEqual(percent, 0)
    }
    
    func testParseVerticalAlignment_positiveOffset() {
        let (align2, percent2) = SvrfViewportBindingExtension
            .parseVerticalAlignment("bottom + 10%")
        XCTAssertEqual(align2, .bottom)
        XCTAssertEqual(percent2, CGFloat(0.10))
    }
    
    func testParseVerticalAlignment_negativeOffset() {
        let (align3, percent3) = SvrfViewportBindingExtension
            .parseVerticalAlignment("center-32%")
        XCTAssertEqual(align3, .center)
        XCTAssertEqual(percent3, CGFloat(-0.32))
    }
    
    



}
