//
//  SignUpViewController.swift
//  UI
//
//  Created by MacPro on 11/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import UIKit
import Presentation

final class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    var signUp:((SignUpViewModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        btnSave.addTarget(self, action: #selector(btnSaveTaped), for: .touchUpInside)
    }
    
    @objc private func btnSaveTaped() {
        signUp?(SignUpViewModel(name: nameTextField?.text, email: emailTextField?.text, password: passwordTextField?.text, passwordConfirmation: passwordConfirmationTextField?.text))
    }
}

extension SignUpViewController: LoadingView {
    func display(viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            self.loadingIndicator.startAnimating()
        } else {
            self.loadingIndicator.stopAnimating()
        }
    }
}

extension SignUpViewController: AlertView {
    func showMessage(viewModel: AlertViewModel) {
        
    }
}
