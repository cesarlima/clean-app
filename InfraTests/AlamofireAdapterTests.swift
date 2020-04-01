//
//  InfraTests.swift
//  InfraTests
//
//  Created by MacPro on 31/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    private let session:Session
    
    init(session:Session = .default) {
        self.session = session
    }
    
    func post(to url: URL) {
        self.session.request(url, method: .post).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {

    func test_() {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration:configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
        
        let exp = expectation(description: "waiting")
        UrlProtocolStub.oberveRequest { (request) in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
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
