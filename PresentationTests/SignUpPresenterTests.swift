//
//  PresentationTests.swift
//  PresentationTests
//
//  Created by MacPro on 03/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest

class SignUpPresenter {
    private let alertView:AlertView
    
    init(alertView:AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel:SignUpViewModel) {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "O campo Nome é obrigatório"))
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "O campo Email é obrigatório"))
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: "O campo Senha é obrigatório"))
        }
    }
}

protocol AlertView {
    func showMessage(viewModel:AlertViewModel)
}

struct AlertViewModel:Equatable {
    var title:String
    var message:String
}

struct SignUpViewModel {
    var name:String?
    var email:String?
    var password:String?
    var passwordConfirmation:String?
}

class SignUpPresenterTests: XCTestCase {
    
    func test_signUP_should_show_error_message_if_name_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(email: "any@email", password: "any-password", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Nome é obrigatório"))
    }
    
    func test_signUP_should_show_error_message_if_email_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(name: "any-name", password: "any-password", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Email é obrigatório"))
    }
    
    func test_signUP_should_show_error_message_if_password_is_not_provided() {
        let (sut, alertViewSpy) = makeSUT()
        let signUpViewModel = SignUpViewModel(name: "any-name", email: "any@email", passwordConfirmation: "any-password")
        sut.signUp(viewModel:signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title:"Falha na validação", message:"O campo Senha é obrigatório"))
    }
}

extension SignUpPresenterTests {
    class AlertViewSpy: AlertView {
        var viewModel:AlertViewModel?
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    func makeSUT() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        return (sut, alertViewSpy)
    }
}

