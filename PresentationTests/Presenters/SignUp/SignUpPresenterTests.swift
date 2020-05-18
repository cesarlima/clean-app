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
            XCTAssertEqual(viewModel, AlertViewModel(title:"Erro", message:"Algo inesperado aconteceu, tente novamente em alguns instantes"))
            exp.fulfill()
        }
        
        sut.signUp(viewModel:makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_email_in_use_message_if_add_account_retuns_email_in_use_error() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, AlertViewModel(title:"Erro", message:"Esse e-mail já está em uso."))
            exp.fulfill()
        }
        
        sut.signUp(viewModel:makeSignUpViewModel())
        addAccountSpy.completeWithError(.emailInUse)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUP_should_show_success_message_if_add_account_success() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSUT(alertView: alertViewSpy, addAccount: addAccountSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, AlertViewModel(title:"Sucesso", message:"Conta criada com sucesso"))
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
    
    func test_singUp_should_call_validation_with_correct_values() {
        let validationSpy = ValidationSpy()
        let sut = makeSUT(validation: validationSpy)
        let viewModel = makeSignUpViewModel()
        sut.signUp(viewModel: viewModel)
        XCTAssertTrue(NSDictionary(dictionary: viewModel.toJson()!).isEqual(to:validationSpy.data!))
    }
    
    func test_signUP_should_show_error_message_if_validation_fails() {
        let alertViewSpy = AlertViewSpy()
        let validationSpy = ValidationSpy()
        let sut = makeSUT(alertView: alertViewSpy, validation: validationSpy)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { (viewModel) in
            XCTAssertEqual(viewModel, AlertViewModel(title:"Falha na validação", message:"Erro"))
            exp.fulfill()
        }
        
        validationSpy.simulateError()
        sut.signUp(viewModel:makeSignUpViewModel())
        
        wait(for: [exp], timeout: 1)
    }
}

extension SignUpPresenterTests {    
    func makeSUT(alertView: AlertViewSpy = AlertViewSpy()
               , addAccount:AddAccountSpy = AddAccountSpy()
               , loadingView:LoadingViewSpy = LoadingViewSpy()
               , validation: ValidationSpy = ValidationSpy()
               , file: StaticString = #file
               , line: UInt = #line) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, addAccount:addAccount, loadingView: loadingView, validation: validation)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
}
