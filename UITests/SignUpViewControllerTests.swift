//
//  UITests.swift
//  UITests
//
//  Created by MacPro on 11/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import XCTest
@testable import UI

class SignUpViewControllerTests: XCTestCase {

    func test_() {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
}
