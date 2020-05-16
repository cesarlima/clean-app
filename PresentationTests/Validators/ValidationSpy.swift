//
//  ValidationSpy.swift
//  PresentationTests
//
//  Created by MacPro on 15/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

class ValidationSpy: Validation {
    var data:[String: Any]?
    private var errorMessage:String?
    
    func validate(data: [String: Any]?) -> String? {
        self.data = data
        return errorMessage
    }
    
    func simulateError() {
        self.errorMessage = "Erro"
    }
}
