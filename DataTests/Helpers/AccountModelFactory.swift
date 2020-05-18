//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by MacPro on 31/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

func makeAccountModel(accessToken:String = "any_token") -> AccountModel {
    return AccountModel(accessToken: accessToken)
}

func makeAddAccountModel(name:String = "any_name"
                       , email:String = "any@email.com"
                       , password:String = "any_password"
                       , passwordConfirmation:String = "any_password") -> AddAccountModel {
    return AddAccountModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
}

func makeAuthenticationModel(email:String = "any@email.com"
                           , password:String = "any_password") -> AuthenticationModel {
    return AuthenticationModel(email: email, password: password)
}
