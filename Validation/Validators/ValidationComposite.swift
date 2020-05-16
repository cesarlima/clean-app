//
//  ValidationComposite.swift
//  Validation
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

public final class ValidationComposite: Validation {
    private let validations:[Validation]
    
    public init(validations:[Validation]) {
        self.validations = validations
    }
    
    public func validate(data: [String : Any]?) -> String? {
        for validation in validations {
            if let errorMessage = validation.validate(data: data) {
                return errorMessage
            }
        }
        return nil
    }
}
