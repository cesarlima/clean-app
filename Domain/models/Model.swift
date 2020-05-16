//
//  Model.swift
//  Domain
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol Model: Codable, Equatable {}

extension Model {
    public func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    public func toJson() -> [String: Any]? {
        guard let data = toData() else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
