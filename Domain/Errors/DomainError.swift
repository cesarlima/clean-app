//
//  DomainError.swift
//  Domain
//
//  Created by MacPro on 30/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public enum DomainError:Error {
    case unexpected
    case emailInUse
    case expiredSession
}
