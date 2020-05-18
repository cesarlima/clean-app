//
//  RemoteAuthentication.swift
//  Data
//
//  Created by MacPro on 18/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain

public final class RemoteAuthentication: Authentication {
    private let url:URL
    private let httpClient:HttpPostClient
    
    public init(url:URL, httpClient:HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    
    public func auth(authenticationModel: AuthenticationModel, completion: @escaping (Authentication.Result) -> Void) {
        self.httpClient.post(to: url, with: authenticationModel.toData()) { [weak self] (result) in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                if let model:AccountModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure(let error):
                switch error {
                case .unauthorized:
                    completion(.failure(.sessionExpired))
                default:
                    completion(.failure(.unexpected))
                }
            }
        }
    }
}
