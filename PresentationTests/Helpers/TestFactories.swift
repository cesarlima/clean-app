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

func makeLoginViewModel(email:String? = "any@email.com", password:String? = "any_password") -> LoginViewModel {
    return LoginViewModel(email: email, password: password)
}
