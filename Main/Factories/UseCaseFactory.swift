//
//  UseCaseFactory.swift
//  Main
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain
import Infra
import Data

final class UseCaseFactory {
    private static let httpClient = AlamofireAdapter()
    private static let apiBaseUrl = Environment.variable(.apiBaseUrl)
    
    private static func makeURL(path:String) -> URL {
        return URL(string: "\(apiBaseUrl)/\(path)")!
    }
    
    static func makeRemoteAddAccout() -> AddAccount {
        return  MainQueueDispatchDecorator(RemoteAddAccount(url: makeURL(path: "signup"), httpClient: httpClient))
    }
}
