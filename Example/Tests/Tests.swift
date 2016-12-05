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

        let aDescriptor = SortDescriptor<Item>(ascending: true) { $0.a }

        let sorted = items.sorted(descriptors: [aDescriptor])

        // Sort order is not defined if SortDescriptor returns orderedSame

        let sortedA = sorted.map { $0.a }

        XCTAssertEqual(sortedA, [1,1,1,1,1,1, 2,2,2,2,2,2])
    }

    func test_SingleKeyPath_SortsDescending() {

        let aDescriptor = SortDescriptor<Item>(ascending: false) { $0.a }

        let sorted = items.sorted(descriptors: [aDescriptor])

        // Sort order is not defined if SortDescriptor returns orderedSame

        let sortedA = sorted.map { $0.a }

        let expected = [
            2,2,2,2,2,2,
            1,1,1,1,1,1
        ]

        XCTAssertEqual(sortedA, expected)
    }

    func test_OptionalKeyPath_SortsAscending() {

        let cDescriptor = SortDescriptor<Item>(ascending: true) { $0.c }

        let sorted = items.sorted(descriptors: [cDescriptor])

        let sortedC = sorted.map { $0.c }

        let expected = [
            nil,nil,nil,nil,
            "1","1","1","1",
            "2","2","2","2"
        ]

        XCTAssertEqual(sortedC, expected)
    }

    func test_OptionalKeyPath_SortsDescending() {

        let cDescriptor = SortDescriptor<Item>(ascending: false) { $0.c }

        let sorted = items.sorted(descriptors: [cDescriptor])

        let sortedC = sorted.map { $0.c }

        let expected = [
            "2","2","2","2",
            "1","1","1","1",
            nil,nil,nil,nil
        ]


        XCTAssertEqual(sortedC, expected)
    }


    func test_MultipleKeyPath_SortsAllAscending() {

        let aDescriptor = SortDescriptor<Item>(ascending: true) { $0.a }
        let bDescriptor = SortDescriptor<Item>(ascending: true) { $0.b }
        let cDescriptor = SortDescriptor<Item>(ascending: true) { $0.c }

        let sorted = items.sorted(descriptors: [aDescriptor, bDescriptor, cDescriptor])

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

        let aDescriptor = SortDescriptor<Item>(ascending: false) { $0.a }
        let bDescriptor = SortDescriptor<Item>(ascending: false) { $0.b }
        let cDescriptor = SortDescriptor<Item>(ascending: false) { $0.c }

        let sorted = items.sorted(descriptors: [aDescriptor, bDescriptor, cDescriptor])

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

        let aDescriptor = SortDescriptor<Item>(ascending: true) { $0.a }
        let bDescriptor = SortDescriptor<Item>(ascending: false) { $0.b }
        let cDescriptor = SortDescriptor<Item>(ascending: true) { $0.c }

        let sorted = items.sorted(descriptors: [aDescriptor, bDescriptor, cDescriptor])

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

        let cExistsDescriptor = SortDescriptor<Item>.exists(nilFirst: true) { $0.c }
        let cDescriptor = SortDescriptor<Item>(ascending: false) { $0.c }
        
        let sorted = items.sorted(descriptors: [cExistsDescriptor, cDescriptor])
        
        let sortedC = sorted.map { $0.c }
        
        let expected = [
            nil, nil, nil, nil,
            "2","2","2","2",
            "1","1","1","1"
        ]
        
        XCTAssertEqual(sortedC, expected)
    }
    
}
