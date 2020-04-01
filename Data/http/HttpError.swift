//
//  HttpError.swift
//  Data
//
//  Created by MacPro on 30/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public enum HttpError:Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
