//
//  AddAccount.swift
//  Domain
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

protocol AddAccount {
    func add(addAccountModel:AddAccountModel, completion:@escaping (Result<AccountModel, Error>) -> Void)
}

struct AddAccountModel {
    var name:String
    var email:String
    var password:String
    var passwordConfirmation:String
}
