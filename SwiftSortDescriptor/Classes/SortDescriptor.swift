//
//  SortDescriptor.swift
//  Pods
//
//  Created by Simon Anreiter on 04/12/2016.
//
//

import Foundation

/** protocol version of SortDescriptor allowing constrained same-type extensions
 
 ```
 extension SortDescriptorType where Base == YourType {
    ...
 }
 ```
 */
public protocol SortDescriptorType {
    associatedtype Base
}

public struct SortDescriptor<T>: SortDescriptorType {
    public typealias Base = T

    public let isAscending: Bool

    private let mapValue: (T)->AnyComparable

    /// returns an ascending version of the sort-descriptor
    public var ascending: SortDescriptor<T> {
        return SortDescriptor(ascending: true, closure: self.mapValue)
    }

    /// returns an descending version of the sort-descriptor
    public var descending: SortDescriptor<T> {
        return SortDescriptor(ascending: false, closure: self.mapValue)
    }

    private init(ascending: Bool, closure: @escaping (T)->AnyComparable) {
        self.mapValue = closure
        self.isAscending = ascending
    }


    public init<V: Comparable>(ascending: Bool = true, mapKey: @escaping (T)->V?) {
        self.isAscending = ascending
        self.mapValue = { AnyComparable(mapKey($0)) }
    }

    public func compare(_ lhs: T, _ rhs:T) -> ComparisonResult {
        let result = mapValue(lhs).compare(mapValue(rhs))

        switch (isAscending, result) {
        case (true,_):
            return result
        case (false, .orderedAscending):
            return .orderedDescending
        case (false, .orderedDescending):
            return .orderedAscending
        case (false, .orderedSame):
            return .orderedSame
        }
    }

    public static func compare(_ lhs: T, _ rhs:T, sortKeys: [SortDescriptor<T>]) -> ComparisonResult {

        var iterator = sortKeys.makeIterator()

        while let current = iterator.next() {
            switch current.compare(lhs, rhs) {
            case .orderedAscending:
                return .orderedAscending
            case .orderedDescending:
                return  .orderedDescending
            case .orderedSame:
                continue
            }
        }
        
        return .orderedAscending
    }

    public static func exists<V: Comparable>(nilFirst ascending: Bool = true, mapKey: @escaping (T)->V?)->SortDescriptor<T> {
        return SortDescriptor<T>(ascending: ascending) {  mapKey($0) == nil ? 0 : 1 }
    }

    public var existsDescriptor: SortDescriptor<T> {
        let mapValue: (T)->AnyComparable = {
            let ordinalValue = self.mapValue($0).base == nil ? 0 : 1
            return AnyComparable(ordinalValue)
        }

        return SortDescriptor<T>(ascending: self.isAscending, closure: mapValue)
    }

}

extension Sequence {
    public func sorted(descriptors: [SortDescriptor<Iterator.Element>]) -> [Iterator.Element] {
        return sorted { return SortDescriptor.compare($0, $1, sortKeys: descriptors) == .orderedAscending }
    }
}
