//
//  Model.swift
//  Domain
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol Model: Encodable {}

extension Model {
    public func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
