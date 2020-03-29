//
//  HttpPostClient.swift
//  Data
//
//  Created by MacPro on 28/03/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol HttpPostClient {
    func post(to url:URL, with:Data?)
}
