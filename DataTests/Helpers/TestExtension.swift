//
//  TestExtension.swift
//  DataTests
//
//  Created by MacPro on 31/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file:StaticString = #file, line:UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
