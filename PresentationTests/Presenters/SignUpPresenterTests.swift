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
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Nome"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(name:nil))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Email"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(email:nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(password:nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(fieldName: "Confirmar Senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel:makeSignUpViewModel(passwordConfirmation:nil))
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_error_message_if_password_confirmation_not_match() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSUT(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "Confirmar Senha"))
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
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(fieldName: "Email"))
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
        alertViewSpy.observe { [weak self] (viewModel) in
            XCTAssertEqual(viewModel, self?.makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em alguns instantes"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel:makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpPresenterTests {
    class AlertViewSpy: AlertView {
        var emit:((AlertViewModel) -> Void)?
        
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
        }
    }
    
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
    
    class AddAccountSpy: AddAccount {
        var addAccountModel: AddAccountModel?
        var completion:((Result<AccountModel, DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        func completeWithError(_ error:DomainError) {
            self.completion?(.failure(error))
        }
    }
    
    func makeSignUpViewModel(name:String? = "any_name", email:String? = "any@email.com", password:String? = "any_password", passwordConfirmation:String? = "any_password") -> SignUpViewModel {
        return SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeRequiredAlertViewModel(fieldName:String) -> AlertViewModel {
        return AlertViewModel(title:"Falha na validação", message:"O campo \(fieldName) é obrigatório")
    }
    
    func makeInvalidAlertViewModel(fieldName:String) -> AlertViewModel {
        return AlertViewModel(title:"Falha na validação", message:"O campo \(fieldName) é inválido")
    }
    
    func makeErrorAlertViewModel(message:String) -> AlertViewModel {
        return AlertViewModel(title:"Erro", message:message)
    }
    
    func makeSUT(alertView: AlertViewSpy = AlertViewSpy()
               , emailValidator: EmailValidatorSpy = EmailValidatorSpy()
        , addAccount:AddAccountSpy = AddAccountSpy()) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount:addAccount)
        return sut
    }
}
