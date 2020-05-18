//
//  RemoteAuthenticationTests.swift
//  DataTests
//
//  Created by MacPro on 18/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Domain
import Data

class RemoteAuthenticationTests: XCTestCase {
    
    func test_add_should_call_httpClient_with_correct_url_one_time() {
        let url = makeURL()
        let (httpClientSpy, sut) = makeSUT(url: url)
        sut.auth(authenticationModel: makeAuthenticationModel()) { _ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let (httpClientSpy, sut) = makeSUT()
        let authenticationModel = makeAuthenticationModel()
        sut.auth(authenticationModel: authenticationModel, completion: { _ in})
        let data = authenticationModel.toData()
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_should_complete_with_error_if_cliente_fails() {
        let (httpClientSpy, sut) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completionWithError(.noConnectivity)
        })
    }
    
    func test_should_complete_with_expired_session_error_when_client_completes_with_unauthorized() {
        let (httpClientSpy, sut) = makeSUT()
        expect(sut, completeWith: .failure(.sessionExpired), when: {
            httpClientSpy.completionWithError(.unauthorized)
        })
    }
    
    func test_should_complete_with_account_model_if_login_success() {
        let (httpClientSpy, sut) = makeSUT()
        let accountModel = makeAccountModel()
        expect(sut, completeWith: .success(accountModel), when: {
            httpClientSpy.completionWithData(accountModel.toData()!)
        })
    }
    
    func test_add_should_complete_with_account_if_client_complete_with_ivalid_data() {
        let (httpClientSpy, sut) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completionWithData(makeInvalidData())
        })
    }
    
    func test_add_should_not_complete_if_sut_has_been_deallocated() {
          let httpClientSpy = HttpClientSpy()
          var sut:RemoteAuthentication? = RemoteAuthentication(url: makeURL(), httpClient: httpClientSpy)
          var result:Authentication.Result?
          
          sut?.auth(authenticationModel: makeAuthenticationModel()) { result = $0}
          sut = nil
          httpClientSpy.completionWithError(.noConnectivity)
          XCTAssertNil(result)
      }
}

extension RemoteAuthenticationTests {
    fileprivate func expect(_ sut:RemoteAuthentication,
                            completeWith expectedResult:Authentication.Result,
                            when action:@escaping() -> Void,
                            file:StaticString = #file,
                            line:UInt = #line) {
        
        let exp = expectation(description: "waiting")
        
        sut.auth(authenticationModel: makeAuthenticationModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
                case (.failure(let expectedResult), .failure(let receivedResult)):
                    XCTAssertEqual(expectedResult, receivedResult, file: file, line: line)
                case (.success(let expectedResult), .success(let receivedResult)):
                    XCTAssertEqual(expectedResult, receivedResult, file: file, line: line)
                default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
    }
    
    fileprivate func makeSUT(url:URL = URL(string: "http://any-url.com")!, file:StaticString = #file, line:UInt = #line) -> (HttpClientSpy, RemoteAuthentication) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAuthentication(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        checkMemoryLeak(for: sut, file: file, line: line)
        return (httpClientSpy, sut)
    }
}
