//
//  Validation.swift
//  Presentation
//
//  Created by MacPro on 15/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol Validation {
    func validate(data: [String: Any]?) -> String?
}
