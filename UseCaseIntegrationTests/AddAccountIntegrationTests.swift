//
//  UseCaseIntegrationTests.swift
//  UseCaseIntegrationTests
//
//  Created by MacPro on 03/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Data
import Infra
import Domain

class AddAccountIntegrationTests: XCTestCase {
    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let addAccountModel = AddAccountModel(name: "César", email: "cesar@mail.com", password: "secret", passwordConfirmation: "secret")
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: addAccountModel) { (result) in
            switch result {
            case .failure: XCTFail("Expect succes got \(result) instead")
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
