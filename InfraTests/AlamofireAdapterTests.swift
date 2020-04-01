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

class AlamofireAdapter {
    private let session:Session
    
    init(session:Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data:Data?, completion: @escaping(Result<Data?, HttpError>) -> Void) {
        let json = data?.toJson()
        self.session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).responseData { (responseData) in
            switch responseData.result {
                case .success:break
                case .failure: completion(.failure(.noConnectivity))
            }
        }
    }
}

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
    
    func test_post_should_complete_with_error_when_request_complete_with_error() {
        let sut = makeSUT()
        UrlProtocolStub.simulate(data: nil, response: nil, error: makeError())
        let ext = expectation(description: "waiting")
        sut.post(to: makeURL(), with: makeValidData()) { result in
            switch result {
                case .success: XCTFail("Expected error got \(result) instead")
                case .failure(let error): XCTAssertEqual(error, HttpError.noConnectivity)
            }
            ext.fulfill()
        }
        
        wait(for: [ext], timeout: 1)
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
}


class UrlProtocolStub: URLProtocol {
    static var emit:((URLRequest) -> Void)?
    static var error:Error?
    static var data:Data?
    static var response:HTTPURLResponse?
    
    static func oberveRequest(completion:@escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    static func simulate(data:Data?, response:HTTPURLResponse?, error:Error?) {
        UrlProtocolStub.data = data
        UrlProtocolStub.response = response
        UrlProtocolStub.error = error
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        UrlProtocolStub.emit?(request)
        
        if let data = UrlProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = UrlProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = UrlProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }

    override open func stopLoading() {}
}
