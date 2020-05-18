//
//  AddAccount.swift
//  Domain
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol Authentication {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func add(authenticationModel:AuthenticationModel, completion:@escaping (Result) -> Void)
}

public struct AuthenticationModel:Model {
    public var email:String
    public var password:String
    
    public init(email:String, password:String) {
        self.email = email
        self.password = password
    }
}
