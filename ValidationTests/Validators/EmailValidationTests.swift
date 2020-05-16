//
//  EmailValidationTests.swift
//  ValidationTests
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Presentation
import Validation

class EmailValidationTests: XCTestCase {

    func test_validate_should_return_error_if_invalid_email_is_provided() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(fieldName: "email", fieldLabel: "Email", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email":"invalid_email@gmail.com"])
        XCTAssertEqual("O campo Email é inválido", errorMessage)
    }
    
    func test_validate_should_return_error_with_correct_field_label() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(fieldName: "email", fieldLabel: "E-mail", emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let errorMessage = sut.validate(data: ["email":"invalid_email@gmail.com"])
        XCTAssertEqual("O campo E-mail é inválido", errorMessage)
    }
    
    func test_validate_should_return_nil_if_email_is_valid() {
        let sut = makeSUT(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: ["email":"invalid_email@gmail.com"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_error_if_data_is_not_provided() {
        let sut = makeSUT(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual("O campo Email é inválido", errorMessage)
    }
}

extension EmailValidationTests {
    func makeSUT(fieldName:String,
                 fieldLabel: String,
                 emailValidator: EmailValidatorSpy = EmailValidatorSpy(),
                 file:StaticString = #file,
                 line:UInt = #line) -> Validation {
        
        let sut = EmailValidation(fieldName: fieldName, fieldLabel: fieldLabel, emailValidator: emailValidator)
        checkMemoryLeak(for: sut)
        
        return sut
    }
}
