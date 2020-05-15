//
//  SignUpComposer.swift
//  Main
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import UI
import Validation
import Infra
import Data
import Presentation
import Domain

public final class SignUpComposer {
    public static func composeControllerWith(addAccount:AddAccount) -> SignUpViewController {
        let controller = SignUpViewController.instantiate()
        let emailValidator = EmailValidatorAdapter()
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), emailValidator: emailValidator, addAccount: addAccount, loadingView: WeakVarProxy(controller))
        controller.signUp = presenter.signUp
        return controller
    }
}
