
//
//  LoginViewModel.swift
//  Presentation
//
//  Created by MacPro on 18/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

public struct LoginRequest: Model {
    public var email:String?
    public var password:String?
    
    public init(email:String?, password:String?) {
        self.email = email
        self.password = password
    }
    
    public func toAuthenticationModel() -> AuthenticationModel {
        return AuthenticationModel(email: email!, password: password!)
    }
}
