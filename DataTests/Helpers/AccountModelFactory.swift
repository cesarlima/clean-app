//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by MacPro on 31/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

func makeAccountModel(id:String = "any id"
                    , name:String = "any name"
                    , email:String = "any email"
                    , password:String = "any password") -> AccountModel {
    return AccountModel(id: id, name: name, email: email, password: password)
}
