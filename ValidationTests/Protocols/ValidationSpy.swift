//
//  ValidationSpy.swift
//  ValidationTests
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

class ValidationSpy: Validation {
    var errorMessage:String?
    var data:[String: Any]?
    
    func validate(data: [String : Any]?) -> String? {
        self.data = data
        return errorMessage
    }
    
    func simulateError(_ errorMessage:String) {
        self.errorMessage = errorMessage
    }
}
