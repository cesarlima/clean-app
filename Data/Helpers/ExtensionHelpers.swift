//
//  ExtensionHelpers.swift
//  Data
//
//  Created by MacPro on 30/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
