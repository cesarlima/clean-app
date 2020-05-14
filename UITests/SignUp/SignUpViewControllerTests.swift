//
//  UITests.swift
//  UITests
//
//  Created by MacPro on 11/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Presentation
@testable import UI

class SignUpViewControllerTests: XCTestCase {

    func test_loading_is_hidden_on_start() {
        let sut = makeSUT()
        XCTAssertEqual(sut.btnSave?.isAnimating, false)
    }
    
    func test_sut_implements_loadingView() {
        let sut = makeSUT()
        XCTAssertNotNil(sut as LoadingView)
    }
    
    func test_sut_implements_alertView() {
        let sut = makeSUT()
        XCTAssertNotNil(sut as AlertView)
    }
    
    func test_when_tap_saveButton_should_calls_signUp() {
        var received:SignUpViewModel?
        let sut = makeSUT { received = $0 }
        let expected = SignUpViewModel(name: sut.nameTextField.text,
                                       email: sut.emailTextField.text,
                                       password: sut.passwordTextField.text,
                                       passwordConfirmation: sut.passwordConfirmationTextField.text)
        sut.btnSave?.simulateTap()
        XCTAssertEqual(expected, received)
    }
}

extension SignUpViewControllerTests {
    func makeSUT(signUpSpy:((SignUpViewModel) -> Void)? = nil) -> SignUpViewController {
        let sut = SignUpViewController.instantiate()
        sut.signUp = signUpSpy
        sut.loadViewIfNeeded()
        return sut
    }
}
