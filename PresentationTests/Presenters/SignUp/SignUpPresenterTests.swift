//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by MacPro on 03/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Presentation
import Domain

class SignUpPresenterTests: XCTestCase {
    func setAletViewObserve(alertView:AlertViewSpy, fieldName:String, action:@escaping (String) -> AlertViewModel) {
        alertView.observe { viewModel in
            XCTAssertEqual(viewModel, action(fieldName))
        }
    }
    func test_signUP_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(fieldName: "Nome"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(name:nil))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(fieldName: "Email"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(email:nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(fieldName: "Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(password:nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(fieldName: "Confirmar Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(passwordConfirmation:nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_password_confirmation_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(fieldName: "Confirmar Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(passwordConfirmation:"wrong-confirmation"))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(signUpViewModel.email, emailValidatorSpy.email)
    }
    
    func test_signUP_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(fieldName: "Email"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_call_addAccount_with_correct_values() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(addAccount:addAccountSpy)
        sut.signUp(viewModel:makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signUP_should_show_error_message_if_add_account_fails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel:makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_success_message_if_add_account_success() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, makeSuccessAlertViewModel(message: "Conta criada com sucesso"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel:makeSignUpViewModel())
        addAccountSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_loading_before_and_after_call_add_account() {
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        let exp = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: true))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
        
        
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel(isLoading: false))
            exp2.fulfill()
        }
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
    }
}

extension SignUpPresenterTests {    
    func makeSUT(alertView: AlertViewSpy = AlertViewSpy()
               , emailValidator: EmailValidatorSpy = EmailValidatorSpy()
               , addAccount:AddAccountSpy = AddAccountSpy()
               , loadingView:LoadingViewSpy = LoadingViewSpy()
               , file: StaticString = #file
               , line: UInt = #line) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount:addAccount, loadingView: loadingView)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
