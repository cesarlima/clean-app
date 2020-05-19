//
//  AddAccountSpy.swift
//  PresentationTests
//
//  Created by MacPro on 06/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

class AuthenticationSpy: Authentication {
    var authenticationModel: AuthenticationModel?
    var completion:((Authentication.Result) -> Void)?
    
    func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        self.authenticationModel = authenticationModel
        self.completion = completion
    }
    
    func completeWithError(_ error:DomainError) {
        self.completion?(.failure(error))
    }
    
    func completeWithAccount(_ account:AccountModel) {
        self.completion?(.success(account))
    }
}
