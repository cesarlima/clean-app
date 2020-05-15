//
//  SignUpIntegrationsTests.swift
//  MainTests
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Main

class SignUpIntegrationsTests: XCTestCase {
    
    func test_signUp_check_memory_leak() {
        
        debugPrint("====================")
        debugPrint(Environment.variable(.apiBaseUrl))
        debugPrint("====================")
        
        let sut = SignUpComposer.composeControllerWith(addAccount: AddAccountSpy())
        checkMemoryLeak(for: sut)
    }
}
