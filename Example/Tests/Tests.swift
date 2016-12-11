import UIKit
import XCTest
import SwiftSortDescriptor

class SortDescriptorTests: XCTestCase {

    struct Item: Equatable {
        let a: Int
        let b: Double
        let c: String?

        static func ==(lhs: Item, rhs: Item)-> Bool {
            return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c
        }
    }


    let items = [
        Item(a: 1, b: 1, c: nil),
        Item(a: 1, b: 1, c: "1"),
        Item(a: 1, b: 1, c: "2"),

        Item(a: 1, b: 2, c: nil),
        Item(a: 1, b: 2, c: "1"),
        Item(a: 1, b: 2, c: "2"),

        Item(a: 2, b: 1, c: nil),
        Item(a: 2, b: 1, c: "1"),
        Item(a: 2, b: 1, c: "2"),

        Item(a: 2, b: 2, c: nil),
        Item(a: 2, b: 2, c: "1"),
        Item(a: 2, b: 2, c: "2")
    ]

    func test_SingleKeyPath_SortsAscending() {

        let aDescriptor = Sort<Item>.by { $0.a }

        let sorted = items.sort(with: [aDescriptor])

        // Sort order is not defined if SortDescriptor returns orderedSame

        let sortedA = sorted.map { $0.a }

        let expected = [
            1,1,1,1,1,1,
            2,2,2,2,2,2
        ]

        XCTAssertEqual(sortedA, expected)
    }

    func test_SingleKeyPath_SortsDescending() {

        let aDescriptor = Sort<Item>.by { $0.a }.descending

        let sorted = items.sort(with: [aDescriptor])

        // Sort order is not defined if SortDescriptor returns orderedSame

        let sortedA = sorted.map { $0.a }

        let expected = [
            2,2,2,2,2,2,
            1,1,1,1,1,1
        ]

        XCTAssertEqual(sortedA, expected)
    }

    func test_OptionalKeyPath_SortsAscending() {

        let cDescriptor = Sort<Item>.by { $0.c }

        let sorted = items.sort(with: [cDescriptor])

        let sortedC = sorted.map { $0.c }

        let expected = [
            nil,nil,nil,nil,
            "1","1","1","1",
            "2","2","2","2"
        ]

        XCTAssertEqual(sortedC, expected)
    }

    func test_OptionalKeyPath_SortsDescending() {

        let cDescriptor = Sort<Item>.by { $0.c }.descending

        let sorted = items.sort(with: [cDescriptor])

        let sortedC = sorted.map { $0.c }

        let expected = [
            "2","2","2","2",
            "1","1","1","1",
            nil,nil,nil,nil
        ]


        XCTAssertEqual(sortedC, expected)
    }


    func test_MultipleKeyPath_SortsAllAscending() {

        let aDescriptor = Sort<Item>.by { $0.a }
        let bDescriptor = Sort<Item>.by { $0.b }
        let cDescriptor = Sort<Item>.by { $0.c }

        let sorted = items.sort(with: [aDescriptor.typeErased(), bDescriptor.typeErased(), cDescriptor.typeErased()])

        let expected = [
            Item(a: 1, b: 1, c: nil),
            Item(a: 1, b: 1, c: "1"),
            Item(a: 1, b: 1, c: "2"),

            Item(a: 1, b: 2, c: nil),
            Item(a: 1, b: 2, c: "1"),
            Item(a: 1, b: 2, c: "2"),

            Item(a: 2, b: 1, c: nil),
            Item(a: 2, b: 1, c: "1"),
            Item(a: 2, b: 1, c: "2"),

            Item(a: 2, b: 2, c: nil),
            Item(a: 2, b: 2, c: "1"),
            Item(a: 2, b: 2, c: "2")
        ]

        XCTAssertEqual(sorted, expected)
    }

    func test_MultipleKeyPaths_SortsAllDescending() {

        let aDescriptor = Sort<Item>.by { $0.a }.descending
        let bDescriptor = Sort<Item>.by { $0.b }.descending
        let cDescriptor = Sort<Item>.by { $0.c }.descending

        let sorted = items.sort(with: [aDescriptor.typeErased(), bDescriptor.typeErased(), cDescriptor.typeErased()])

        let expected = [
            Item(a: 2, b: 2, c: "2"),
            Item(a: 2, b: 2, c: "1"),
            Item(a: 2, b: 2, c: nil),

            Item(a: 2, b: 1, c: "2"),
            Item(a: 2, b: 1, c: "1"),
            Item(a: 2, b: 1, c: nil),

            Item(a: 1, b: 2, c: "2"),
            Item(a: 1, b: 2, c: "1"),
            Item(a: 1, b: 2, c: nil),

            Item(a: 1, b: 1, c: "2"),
            Item(a: 1, b: 1, c: "1"),
            Item(a: 1, b: 1, c: nil)
        ]

        XCTAssertEqual(sorted, expected)
    }

    func test_MultipleKeyPath_SortsMixed() {

        let aDescriptor = Sort<Item>.by { $0.a }
        let bDescriptor = Sort<Item>.by { $0.b }.descending
        let cDescriptor = Sort<Item>.by { $0.c }

        let sorted = items.sort(with: [aDescriptor.typeErased(), bDescriptor.typeErased(), cDescriptor.typeErased()])

        let expected = [
            Item(a: 1, b: 2, c: nil),
            Item(a: 1, b: 2, c: "1"),
            Item(a: 1, b: 2, c: "2"),

            Item(a: 1, b: 1, c: nil),
            Item(a: 1, b: 1, c: "1"),
            Item(a: 1, b: 1, c: "2"),

            Item(a: 2, b: 2, c: nil),
            Item(a: 2, b: 2, c: "1"),
            Item(a: 2, b: 2, c: "2"),

            Item(a: 2, b: 1, c: nil),
            Item(a: 2, b: 1, c: "1"),
            Item(a: 2, b: 1, c: "2")
        ]

        XCTAssertEqual(sorted, expected)
    }

    func test_CustomOptionalSorting() {

        let cExistsDescriptor = Sort<Item>.by { $0.c }.existence
        let cDescriptor = Sort<Item>.by { $0.c }.descending
        
        let sorted = items.sort(with: [cExistsDescriptor.typeErased(), cDescriptor.typeErased()])
        
        let sortedC = sorted.map { $0.c }
        
        let expected = [
            nil, nil, nil, nil,
            "2","2","2","2",
            "1","1","1","1"
        ]
        
        XCTAssertEqual(sortedC, expected)
    }
    
}
