//
//  RequiredFieldValidationTests.swift
//  ValidationTests
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Validation

class CompareFieldsValidationTests: XCTestCase {

    func test_validate_should_return_error_if_comparation_fails() {
        let sut = makeSUT(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Senha")
        let errorMessage = sut.validate(data: ["password" : "abc", "passwordConfirmation" : "123"])
        XCTAssertEqual("O campo Senha é inválido", errorMessage)
    }
    
    func test_validate_should_return_error_with_correct_field_label() {
        let sut = makeSUT(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar Senha")
        let errorMessage = sut.validate(data: ["password" : "abc", "passwordConfirmation" : "123"])
        XCTAssertEqual("O campo Confirmar Senha é inválido", errorMessage)
    }
    
    func test_validate_should_return_nil_if_confirmation_valid() {
        let sut = makeSUT(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Confirmar Senha")
        let errorMessage = sut.validate(data: ["password" : "abc", "passwordConfirmation" : "abc"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_error_if_data_is_not_provided() {
        let sut = makeSUT(fieldName: "password", fieldNameToCompare: "passwordConfirmation", fieldLabel: "Senha")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual("O campo Senha é inválido", errorMessage)
    }
}

extension CompareFieldsValidationTests {
    func makeSUT(fieldName:String, fieldNameToCompare: String, fieldLabel: String, file:StaticString = #file, line:UInt = #line) -> CompareFieldValidation {
        let sut = CompareFieldValidation(fieldName: fieldName,fieldNameToCompare: fieldNameToCompare,  fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
