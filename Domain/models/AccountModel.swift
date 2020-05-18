//
//  AccountModel.swift
//  Domain
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public struct AccountModel:Model {
    public var accessToken:String
    
    public init(accessToken:String) {
        self.accessToken = accessToken
    }
}
