//
//  SignUpViewController.swift
//  UI
//
//  Created by MacPro on 11/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import UIKit
import Presentation

public final class SignUpViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var btnSave: LoadingButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    public var signUp:((SignUpViewModel) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        btnSave.addTarget(self, action: #selector(btnSaveTaped), for: .touchUpInside)
        configureHideKeyboardOnTap()
    }
    
    @objc private func btnSaveTaped() {
        signUp?(SignUpViewModel(name: nameTextField?.text, email: emailTextField?.text, password: passwordTextField?.text, passwordConfirmation: passwordConfirmationTextField?.text))
    }
}

extension SignUpViewController: LoadingView {
    public func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            self.view.isUserInteractionEnabled = false
            self.btnSave.showLoading()
        } else {
            self.view.isUserInteractionEnabled = true
            self.btnSave.hideLoading()
        }
    }
}

extension SignUpViewController: AlertView {
    public func showMessage(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
