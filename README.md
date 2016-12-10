# SwiftSortDescriptor

[![CI Status](https://travis-ci.org/anreitersimon/SwiftSortDescriptor.svg?branch=master)](https://travis-ci.org/anreitersimon/SwiftSortDescriptor)
[![Version](https://img.shields.io/cocoapods/v/SwiftSortDescriptor.svg?style=flat)](http://cocoapods.org/pods/SwiftSortDescriptor)
[![License](https://img.shields.io/cocoapods/l/SwiftSortDescriptor.svg?style=flat)](http://cocoapods.org/pods/SwiftSortDescriptor)
[![Platform](https://img.shields.io/cocoapods/p/SwiftSortDescriptor.svg?style=flat)](http://cocoapods.org/pods/SwiftSortDescriptor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

```swift
struct Item {
    let a: Int
    let b: Int
    let c: String?
}

let items = [
  Item(a: 1, b: nil),
  Item(a: 1, b: "1"),
  Item(a: 1, b: "2"),
  Item(a: 2, b: nil),
  Item(a: 2, b: "1"),
  Item(a: 2, b: "2")
]


// create a SortDescriptor which sorts
// In the closure return the "keyPath" on which you want to sort
let aDescriptor = SortDescriptor<Item>(ascending: false) { $0.a }

// by default SortDescriptors sort ascending
let bDescriptor = SortDescriptor<Item>() { $0.b }

let sorted = items.sorted(descriptors: [aDescriptor, bDescriptor])

/*sorted now contains:
a: 2, b: nil,
a: 2, b: "1",
a: 2, b: "2"
a: 1, c: nil,
a: 1, b: "1",
a: 1, b: "2",
*/

```

### Sorting on Optional Properties

When evaluating Optionals the following rule is applied:

`.none < .some(_) == true`

Most of the time this is the desired behaviour.

To get around this i recommend using a second SortDescriptor like this:

#### Example
```swift
// Items should be sorted in the following order:
// - b descending items which are nil should appear first
// - a ascending


let bDescriptor = SortDescriptor<Item>() { $0.b }
let aDescriptor = SortDescriptor<Item>(ascending: false) { $0.a }

var bExistsDescriptor = SortDescriptor<Item>(ascending: true) { $0.b != nil }

// This can be confusing
// For this purpose a helper method can be used

bExistsDescriptor = SortDescriptor<Item>.exists(nilFirst: true) { $0.b }


// or create from an existing SortDescriptor

bExistsDescriptor = bDescriptor.existsDescriptor


let sorted = items.sorted(descriptors: [aDescriptor, bDescriptor])

/*sorted now contains:
a: 2, b: nil,
a: 1, c: nil,
a: 2, b: "1",
a: 1, b: "1",
a: 2, b: "2"
a: 1, b: "2",
*/

```


## Requirements

## Installation

SwiftSortDescriptor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftSortDescriptor"
```

## Author

Simon Anreiter, simon.anreiter@i-mobility.at

## License

SwiftSortDescriptor is available under the MIT license. See the LICENSE file for more info.
