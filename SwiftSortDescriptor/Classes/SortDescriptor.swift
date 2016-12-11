//
//  SortDescriptor.swift
//  Pods
//
//  Created by Simon Anreiter on 04/12/2016.
//
//

import Foundation

public struct Sort<T> {

    public static func by<V: Comparable>(ascending: Bool = true, transform: @escaping (T)->V?)-> SortDescriptor<T, V> {
        return SortDescriptor(ascending: ascending, transform: transform)
    }

    public static func compare(_ lhs: T, _ rhs:T, descriptors: [SortDescriptor<T, AnyComparable>]) -> ComparisonResult {

        var iterator = descriptors.makeIterator()

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
}

public struct SortDescriptor<T,V: Comparable> {
    public typealias ValueMapper = (T)->V?

    public let isAscending: Bool

    fileprivate let mapValue: ValueMapper

}

extension SortDescriptor: SortDescriptorType, GenericSortDescriptorType {
    public typealias Base = T
    public typealias MappedValue = V
    

    public func asSortDescriptor() -> SortDescriptor<T,V> {
        return self
    }
}

extension SortDescriptor {

    public init(ascending: Bool = true, transform: @escaping ValueMapper) {
        self.isAscending = ascending
        self.mapValue = transform
    }

    public func compare(_ lhs: T, _ rhs:T) -> ComparisonResult {
        let lhsAny = AnyComparable(mapValue(lhs))
        let rhsAny = AnyComparable(mapValue(rhs))


        let result = lhsAny.compare(rhsAny)

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
}

extension SortDescriptorType {

    public func map<V2: Comparable>(transform: @escaping (MappedValue?)->V2? )->SortDescriptor<Base,V2> {
        let s = self.asSortDescriptor()
        return SortDescriptor<Base,V2>(ascending: s.isAscending) {
            return transform(s.mapValue($0))
        }
    }

    /// returns an ascending version of the sort-descriptor
    public var ascending: SortDescriptor<Base, MappedValue> {
        return SortDescriptor(ascending: true, transform: self.asSortDescriptor().mapValue)
    }

    /// returns an descending version of the sort-descriptor
    public var descending: SortDescriptor<Base, MappedValue> {
        return SortDescriptor(ascending: false, transform: self.asSortDescriptor().mapValue)
    }


    public var existence: SortDescriptor<Base, Int> {
        return self.map { $0 == nil ? 0 : 1 }
    }
}

