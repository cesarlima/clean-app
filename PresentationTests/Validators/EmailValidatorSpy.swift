//
//  EmailValidatorSpy.swift
//  PresentationTests
//
//  Created by MacPro on 06/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

class EmailValidatorSpy: EmailValidator {
    var isValid = true
    var email:String?
    
    func isValid(email:String) -> Bool {
        self.email = email
        return self.isValid
    }
    
    func simulateInvalidEmail() {
        isValid = false
    }
}
