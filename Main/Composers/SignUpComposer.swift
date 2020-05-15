//
//  SignUpComposer.swift
//  Main
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain
import UI

public final class SignUpComposer {
    static func composeControllerWith(addAccount:AddAccount) -> SignUpViewController {
        return ControllerFactory.createSignUpWith(addAccount: addAccount)
    }
}
