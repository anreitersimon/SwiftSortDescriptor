//
//  ViewController.swift
//  SwiftSortDescriptor
//
//  Created by Simon Anreiter on 12/05/2016.
//  Copyright (c) 2016 Simon Anreiter. All rights reserved.
//

import UIKit

import SwiftSortDescriptor

extension SortDescriptorType where MappedValue == String {
    var caseInsensitive: SortDescriptor<Base, String> {
        return self.asSortDescriptor().map { $0?.lowercased() }
    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

