//
//  InfraTests.swift
//  InfraTests
//
//  Created by MacPro on 31/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Alamofire
import Data
import Domain
import Infra

class AlamofireAdapterTests: XCTestCase {

    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeURL()

        testRequestFor(url: url, data: makeValidData()) { (request) in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(data: nil) { (request) in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complete_with_no_data_when_request_completes_with_status_code_204() {
        expectResult(.success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error:nil))
        expectResult(.success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error:nil))
    }
    
    func test_post_should_complete_with_data_when_request_completes_with_status_code_200() {
        let data = makeValidData()
        expectResult(.success(data), when: (data: data, response: makeHttpResponse(), error:nil))
    }
    
    func test_post_should_complete_with_error_when_request_complete_with_error() {
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error:makeError()))
    }
    
    func test_post_should_complete_with_error_when_request_complete_with_non_200() {
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error:nil))
        expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error:nil))
        expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error:nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error:nil))
    }
    
    func test_post_should_complete_with_error_on_all_invalid_cases() {
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(), error:makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error:makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error:nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error:makeError()))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error:nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error:nil))
    }
}

extension AlamofireAdapterTests {
    fileprivate func makeSUT(file: StaticString = #file, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration:configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    fileprivate func testRequestFor(url:URL = makeURL(), data:Data?, action:@escaping (URLRequest) -> Void) {
        let sut = makeSUT()
        let exp = expectation(description: "waiting")
        sut.post(to: url, with: data) { _ in exp.fulfill() }
        var request:URLRequest?
        UrlProtocolStub.oberveRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    fileprivate func expectResult(_ expectedResult:Result<Data?, HttpError>,
                                  when stub:(data:Data?, response:HTTPURLResponse?, error:Error?),
                                  file: StaticString = #file, line: UInt = #line) {
        
        let sut = makeSUT()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let ext = expectation(description: "waiting")
        sut.post(to: makeURL(), with: makeValidData()) { receivedResult in
            switch (expectedResult, receivedResult) {
                case (.success(let expectedData), .success(let receivedData)):
                    XCTAssertEqual(expectedData, receivedData, file: file, line: line)
                case (.failure(let expectedError), .failure(let receivedError)):
                    XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                default:
                    XCTFail("Expected error got \(receivedResult) instead", file: file, line: line)
            }
            ext.fulfill()
        }
        
        wait(for: [ext], timeout: 1)
    }
}
