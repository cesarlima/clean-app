//
//  RemoteAddAccount.swift
//  Data
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

public class RemoteAddAccount {
    private let url:URL
    private let httpClient:HttpPostClient
    
    public init(url:URL, httpClient:HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel:AddAccountModel, completion:@escaping(DomainError) -> Void) {
        let data = addAccountModel.toData()
        httpClient.post(to: self.url,with: data) { error in
            completion(.unexpected)
        }
    }
}
