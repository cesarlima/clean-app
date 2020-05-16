//
//  EmailValidator.swift
//  Presentation
//
//  Created by MacPro on 03/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol EmailValidator {
    func isValid(email:String) -> Bool
}
