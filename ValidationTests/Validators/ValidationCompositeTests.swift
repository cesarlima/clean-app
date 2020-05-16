//
//  ValidationCompositeTests.swift
//  ValidationTests
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Presentation
import Validation

class ValidationCompositeTests: XCTestCase {

    func test_validate_should_return_error_if_validation_fails() {
        let validationSpy = ValidationSpy()
        let sut = makeSUT(validations: [validationSpy])
        validationSpy.simulateError("Erro")
        let errorMessage = sut.validate(data: ["name": "Cesar"])
        XCTAssertEqual("Erro", errorMessage)
    }
    
    func test_validate_should_return_correct_error_message() {
        let validationSpy = ValidationSpy()
        let sut = makeSUT(validations: [validationSpy])
        validationSpy.simulateError("Erro 2")
        let errorMessage = sut.validate(data: ["name": "Cesar"])
        XCTAssertEqual("Erro 2", errorMessage)
    }
    
    func test_validate_should_return_nil_if_validation_success() {
        let validationSpy = ValidationSpy()
        let sut = makeSUT(validations: [validationSpy])
        let errorMessage = sut.validate(data: ["name": "Cesar"])
        XCTAssertNil( errorMessage)
    }
    
    func test_validate_should_call_validation_with_correct_data() {
        let validationSpy = ValidationSpy()
        let sut = makeSUT(validations: [validationSpy])
        let data = ["name": "Cesar"]
        _ = sut.validate(data: data)
        XCTAssertTrue(NSDictionary(dictionary: data).isEqual(to: validationSpy.data))
    }
}

extension ValidationCompositeTests {
    func makeSUT(validations:[Validation], file:StaticString = #file, line:UInt = #line) -> ValidationComposite {
        let sut = ValidationComposite(validations: validations)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
