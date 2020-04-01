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

class AlamofireAdapter {
    private let session:Session
    
    init(session:Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data:Data?) {
        let json = data?.toJson()
        self.session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).resume()
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
        sut.post(to: url, with: data)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.oberveRequest { (request) in
            action(request)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}


class UrlProtocolStub: URLProtocol {
    static var emit:((URLRequest) -> Void)?
    
    static func oberveRequest(completion:@escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }

    override open func stopLoading() {}
}
