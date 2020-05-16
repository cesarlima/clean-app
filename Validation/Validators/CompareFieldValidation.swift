
//
//  RequiredFieldValidation.swift
//  Validation
//
//  Created by MacPro on 16/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

public final class CompareFieldValidation: Validation, Equatable {
    private let fieldName: String
    private let fieldNameToCompare: String
    private let fieldLabel: String
    
    public init(fieldName: String, fieldNameToCompare: String, fieldLabel: String) {
        self.fieldName = fieldName
        self.fieldNameToCompare = fieldNameToCompare
        self.fieldLabel = fieldLabel
    }
    
    public func validate(data: [String : Any]?) -> String? {
        guard let fieldName = data?[fieldName] as? String,
            let fieldNameToCompare = data?[fieldNameToCompare] as? String,
            fieldName == fieldNameToCompare
            else {
                return "O campo \(fieldLabel) é inválido"
        }
        
        return nil
    }
    
    public static func == (lhs: CompareFieldValidation, rhs: CompareFieldValidation) -> Bool {
        return lhs.fieldName == rhs.fieldName
            && lhs.fieldLabel == rhs.fieldLabel
            && lhs.fieldNameToCompare == rhs.fieldNameToCompare
    }
}
