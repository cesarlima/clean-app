//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by MacPro on 03/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Presentation

class SignUpPresenterTests: XCTestCase {
    
    func test_signUP_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(email: "any@email", password: "any-password", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Nome é obrigatório"))
    }
    
    func test_signUP_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any-name", password: "any-password", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Email é obrigatório"))
    }
    
    func test_signUP_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any-name", email: "any@email", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Senha é obrigatório"))
    }
    
    func test_signUP_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any-name", email: "any@email", password: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Confirmar Senha é obrigatório"))
    }
    
    func test_signUP_should_show_error_message_if_password_confirmation_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let signUpViewModel = SignUpViewModel(name: "any-name", email: "any@email", password: "any-password", passwordConfirmation: "wrong-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"Falha ao confirmar senha"))
    }
    
    func test_signUP_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any-name", email: "invalid_email@email", password: "any-password", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(signUpViewModel.email, emailValidatorSpy.email)
    }
    
    func test_signUP_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSUT(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = SignUpViewModel(name: "any-name", email: "any@email", password: "any-password", passwordConfirmation: "any-password")
        emailValidatorSpy.isValid = false
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"Email inválido"))
    }
}

extension SignUpPresenterTests {
    class AlertViewSpy: AlertView {
        var viewModel:AlertViewModel?
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    class EmailValidatorSpy: EmailValidator {
        var isValid = true
        var email:String?
        
        func isValid(email:String) -> Bool {
            self.email = email
            return self.isValid
        }
    }
    
    func makeSUT(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator)
        return sut
    }
}
