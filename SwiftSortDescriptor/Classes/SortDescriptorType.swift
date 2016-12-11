//
//  SortDescriptorType.swift
//  Pods
//
//  Created by Simon Anreiter on 10/12/2016.
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
    associatedtype MappedValue: Comparable

    func asSortDescriptor()->SortDescriptor<Base,MappedValue>
}


public protocol GenericSortDescriptorType {
    associatedtype Base

    func typeErased() -> SortDescriptor<Base, AnyComparable>
}

extension SortDescriptorType {
    public func typeErased() -> SortDescriptor<Base, AnyComparable> {
        return asSortDescriptor().map { AnyComparable($0) }
    }
}

