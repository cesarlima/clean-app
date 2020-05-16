//
//  ValidationTests.swift
//  ValidationTests
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Infra

class EmailValidatorAdapterTests: XCTestCase {

    func test_invalid_emails() {
        let sut = EmailValidatorAdapter()
        XCTAssertFalse(sut.isValid(email: ""))
        XCTAssertFalse(sut.isValid(email: "@12adf"))
        XCTAssertFalse(sut.isValid(email: "asdfe@"))
        XCTAssertFalse(sut.isValid(email: "asr@email"))
        XCTAssertFalse(sut.isValid(email: "@mail.com"))
    }
    
    func test_valid_emails() {
        let sut = EmailValidatorAdapter()
        XCTAssertTrue(sut.isValid(email: "email@mail.com"))
        XCTAssertTrue(sut.isValid(email: "mail@mail.io"))
        XCTAssertTrue(sut.isValid(email: "mail@mail.com.br"))
    }
}
