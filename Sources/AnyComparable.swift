//
//  AnyComparable.swift
//  Pods
//
//  Created by Simon Anreiter on 04/12/2016.
//
//

import Foundation

/// type erased wrapper for objects conforming to Comparable
struct AnyComparable: Comparable {

    private let compareClosure: (AnyComparable)->ComparisonResult
    let base: Any?

    init<T: Comparable>(_ value: T?) {
        self.base = value

        self.compareClosure = { other in
            let o = other.base as? T

            switch (value, o) {
            case (.none, .none):
                return .orderedSame
            case (.some(let lhs), .some(let rhs)):
                if lhs == rhs {
                    return .orderedSame
                }
                return lhs < rhs ? .orderedAscending : .orderedDescending
            case (.none, .some(_)):
                return .orderedAscending
            case (.some(_), .none):
                return .orderedDescending
            }
        }
    }

    /// compares wrapped values with rule:
    ///
    /// `.none < .some()`
    func compare(_ val: AnyComparable) -> ComparisonResult {
        return self.compareClosure(val)
    }

    public static func <(lhs: AnyComparable, rhs: AnyComparable) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }

    public static func ==(lhs: AnyComparable, rhs: AnyComparable) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
}
