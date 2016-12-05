//
//  XCTestCase+Extension.swift
//  SwiftSortDescriptor
//
//  Created by Simon Anreiter on 05/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

func XCTAssertEqual<T: Equatable>(_ expression1: @autoclosure () throws -> [T?], _ expression2: @autoclosure () throws -> [T?], file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(expression1, expression2, "\(try! expression1()) is not equal to \(try! expression2())", file: file, line: line)
}

func XCTAssertEqual<T: Equatable>(_ expression1: @autoclosure () throws -> [T?], _ expression2: @autoclosure () throws -> [T?], _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    let e1 = try! expression1()
    let e2 = try! expression2()

    guard e1.count == e2.count else {
        XCTFail(message, file: file, line: line)
        return
    }

    for (lhs, rhs) in zip(e1, e2) {
        guard lhs == rhs else {
            XCTFail(message, file: file, line: line)
            return
        }
    }
}
