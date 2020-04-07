//
//  AddAccountSpy.swift
//  PresentationTests
//
//  Created by MacPro on 06/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

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
    
    func completeWithAccount(_ account:AccountModel) {
        self.completion?(.success(account))
    }
}
