//
//  UIViewControllerExtensions.swift
//  UI
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureHideKeyboardOnTap() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBorad))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func hideKeyBorad() {
        view.endEditing(true)
    }
}
