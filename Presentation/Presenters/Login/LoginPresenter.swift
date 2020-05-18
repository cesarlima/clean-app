//
//  LoginPresenter.swift
//  Presentation
//
//  Created by MacPro on 18/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

public final class LoginPresenter {
    private let alertView:AlertView
    private let loadingView:LoadingView
//    private let authentication:Authentication
    private let validation:Validation
    
    public init(alertView:AlertView, loadingView:LoadingView, validation:Validation) {
        self.alertView = alertView
//        self.authentication = authentication
        self.loadingView = loadingView
        self.validation = validation
    }
    
    public func login(viewModel:LoginViewModel) {
        if let message = validation.validate(data: viewModel.toJson()) {
            self.alertView.showMessage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        } else {
            
        }
    }
}
