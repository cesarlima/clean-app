//
//  TestFactories.swift
//  PresentationTests
//
//  Created by MacPro on 06/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

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

func makeSuccessAlertViewModel(message:String) -> AlertViewModel {
    return AlertViewModel(title:"Sucesso", message:message)
}
