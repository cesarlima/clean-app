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
    
    func test_add_should_call_httpClient_with_correct_url_one_time() {
        let url = URL(string: "http://any-url.com")!
        let (httpClientSpy, sut) = makeSUT(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() {
        let (httpClientSpy, sut) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) { _ in }
        let data = addAccountModel.toData()
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_add_should_complete_with_error_if_client_fails() {
        let (httpClientSpy, sut) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completionWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_account_if_client_complete_with_ivalid_data() {
        let (httpClientSpy, sut) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completionWithData(Data("invalid data".utf8))
        })
    }
    
    func test_add_should_complete_with_account_if_client_complete_with_valid_data() {
        let (httpClientSpy, sut) = makeSUT()
        let expectedData = makeAccountModel()
        expect(sut, completeWith: .success(expectedData), when: {
            httpClientSpy.completionWithData(expectedData.toData()!)
        })
    }
}

extension RemoteAddAccountTests {
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data:Data?
        var completion:((Result<Data?, HttpError>) -> Void)?
        
        func post(to url: URL, with data:Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completionWithError(_ error:HttpError) {
            self.completion?(.failure(error))
        }
        
        func completionWithData(_ data:Data) {
            self.completion?(.success(data))
        }
    }
    
    fileprivate func expect(_ sut:RemoteAddAccount, completeWith expectedResult:Result<AccountModel, DomainError>, when action:@escaping() -> Void,
                            file:StaticString = #file, line:UInt = #line) {
        let exp = expectation(description: "waiting")
        
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
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
    
    fileprivate func makeAccountModel(id:String = "any id"
                                    , name:String = "any name"
                                    , email:String = "any email"
                                    , password:String = "any password") -> AccountModel {
        return AccountModel(id: id, name: name, email: email, password: password)
    }
}
