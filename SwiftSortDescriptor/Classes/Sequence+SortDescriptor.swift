//
//  Sequence+SortDescriptor.swift
//  Pods
//
//  Created by Simon Anreiter on 10/12/2016.
//
//

import Foundation

extension Sequence {
    public func sort<S: GenericSortDescriptorType where S.Base == Self.Iterator.Element>(with descriptors: [S]) -> [Iterator.Element] {

        let asDescriptors = descriptors.map { $0.typeErased() }

        return self.sorted { item1, item2 in
            return Sort<Self.Iterator.Element>.compare(item1, item2, descriptors: asDescriptors) == .orderedAscending
        }
    }
}
