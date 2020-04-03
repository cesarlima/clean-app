//
//  AlamofireAdapter.swift
//  Infra
//
//  Created by MacPro on 02/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Data
import Alamofire

public final class AlamofireAdapter:HttpPostClient {
    private let session:Session
    
    public init(session:Session = .default) {
        self.session = session
    }
    
    public func post(to url: URL, with data:Data?, completion: @escaping(Result<Data?, HttpError>) -> Void) {
        let json = data?.toJson()
        self.session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).responseData { (responseData) in
            guard let statusCode = responseData.response?.statusCode else { return completion(.failure(.noConnectivity)) }
            switch responseData.result {
                case .success(let data):
                    switch statusCode {
                        case 204:
                             completion(.success(nil))
                        case 200...299:
                            completion(.success(data))
                        case 401:
                            completion(.failure(.unauthorized))
                        case 403:
                            completion(.failure(.forbidden))
                        case 400...499:
                            completion(.failure(.badRequest))
                        case 500...599:
                            completion(.failure(.serverError))
                        default:
                            completion(.failure(.noConnectivity))
                    }
                    
                case .failure: completion(.failure(.noConnectivity))
            }
        }
    }
}
