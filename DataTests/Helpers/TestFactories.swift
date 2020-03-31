//
//  TestFactories.swift
//  DataTests
//
//  Created by MacPro on 31/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

func makeURL() -> URL {
    return  URL(string: "http://any-url.com")!
}

func makeInvalidData() -> Data {
    return Data("invalid data".utf8)
}
