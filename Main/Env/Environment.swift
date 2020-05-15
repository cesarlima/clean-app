//
//  Environment.swift
//  Main
//
//  Created by MacPro on 15/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public final class Environment {
    public enum EnvironmentVariables: String {
        case apiBaseUrl = "API_BASE_URL"
    }
    
    public static func variable(_ key:EnvironmentVariables) -> String {
        return Bundle.main.infoDictionary![key.rawValue] as! String
    }
}
