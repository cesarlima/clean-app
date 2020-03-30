//
//  AccountModel.swift
//  Domain
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public struct AccountModel:Model {
    public var id:String
    public var name:String
    public var email:String
    public var password:String
    
    public init(id:String, name:String, email:String, password:String) {
        self.name = name
        self.email = email
        self.password = password
        self.id = id
    }
}
