//
//  RequiredFieldValidationTests.swift
//  ValidationTests
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Validation

class RequiredFieldValidationTests: XCTestCase {

    func test_validate_should_return_error_if_field_is_not_provided() {
        let sut = makeSUT(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: ["name" : "name"])
        XCTAssertEqual("O campo Email é obrigatório", errorMessage)
    }
    
    func test_validate_should_return_error_with_correct_field_label() {
        let sut = makeSUT(fieldName: "age", fieldLabel: "Idade")
        let errorMessage = sut.validate(data: ["name" : "name"])
        XCTAssertEqual("O campo Idade é obrigatório", errorMessage)
    }
    
    func test_validate_should_return_nil_if_field_is_provided() {
        let sut = makeSUT(fieldName: "name", fieldLabel: "Nome")
        let errorMessage = sut.validate(data: ["name" : "name"])
        XCTAssertNil(errorMessage)
    }
    
    func test_validate_should_return_error_if_data_is_not_provided() {
        let sut = makeSUT(fieldName: "email", fieldLabel: "Email")
        let errorMessage = sut.validate(data: nil)
        XCTAssertEqual("O campo Email é obrigatório", errorMessage)
    }
}

extension RequiredFieldValidationTests {
    
    func makeSUT(fieldName:String, fieldLabel: String, file:StaticString = #file, line:UInt = #line) -> RequiredFieldValidation {
        let sut = RequiredFieldValidation(fieldName: fieldName, fieldLabel: fieldLabel)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
