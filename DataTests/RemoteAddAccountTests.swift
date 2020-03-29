//
//  DataTests.swift
//  DataTests
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (httpClientSpy, sut) = makeSUT(url: url)
        sut.add(addAccountModel: makeAddAccountModel())
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let (httpClientSpy, sut) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel)
        let data = addAccountModel.toData()
        XCTAssertEqual(httpClientSpy.data, data)
    }
}

extension RemoteAddAccountTests {
    class HttpClientSpy: HttpPostClient {
        var url:URL?
        var data:Data?
        
        func post(to url: URL, with data:Data?) {
            self.url = url
            self.data = data
        }
    }
    
    fileprivate func makeSUT(url:URL = URL(string: "http://any-url.com")!) -> (HttpClientSpy, RemoteAddAccount) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (httpClientSpy, sut)
    }
    
    fileprivate func makeAddAccountModel(name:String = "any name"
                          , email:String = "any email"
                          , password:String = "any password"
                          , passwordConfirmation:String = "any password") -> AddAccountModel {
        return AddAccountModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
}
