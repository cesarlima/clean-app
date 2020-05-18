//
//  LoginPresenterTests.swift
//  PresentationTests
//
//  Created by MacPro on 18/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Presentation
import Domain

class LoginPresenterTests: XCTestCase {
    func test_login_should_call_validation_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSUT(validation: validationSpy)
        let viewModel = makeLoginViewModel()
        sut.login(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: viewModel.toJson()!).isEqual(to:validationSpy.data!))
    }
    
    func test_login_should_show_error_message_if_validation_fails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSUT(alertView: alertViewSpy, validation: validationSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, AlertViewModel(title:"Falha na validação", message:"Erro"))
            exp.fulfill()
        }
        
        validationSpy.simulateError()
        sut.login(viewModel:makeLoginViewModel())
        
        wait(for: [exp], timeout: 1)
    }
}

extension LoginPresenterTests {
    func makeSUT(alertView: AlertViewSpy = AlertViewSpy()
               , loadingView:LoadingViewSpy = LoadingViewSpy()
               , validation: ValidationSpy = ValidationSpy()
               , file: StaticString = #file
               , line: UInt = #line) -> LoginPresenter {
        let sut = LoginPresenter(alertView: alertView, loadingView: loadingView, validation: validation)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
