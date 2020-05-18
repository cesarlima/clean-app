//
//  RemoteAddAccount.swift
//  Data
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

public class RemoteAddAccount: AddAccount {
    private let url:URL
    private let httpClient:HttpPostClient
    
    public init(url:URL, httpClient:HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel:AddAccountModel, completion:@escaping(Result<AccountModel, DomainError>) -> Void) {
        let data = addAccountModel.toData()
        httpClient.post(to: self.url,with: data) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case .success(let data):
                    if let model:AccountModel = data?.toModel() {
                        completion(.success(model))
                    } else {
                        completion(.failure(.unexpected))
                    }
                
                case .failure(let error):
                    debugPrint("====================================")
                    debugPrint(error)
                    completion(.failure(.unexpected))
            }
        }
    }
}
