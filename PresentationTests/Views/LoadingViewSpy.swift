//
//  LoadingViewSpy.swift
//  PresentationTests
//
//  Created by MacPro on 06/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Presentation

class LoadingViewSpy: LoadingView {
            var emit:((LoadingViewModel) -> Void)?
    
    func observe(completion: @escaping (LoadingViewModel) -> Void) {
        self.emit = completion
    }
    
    func display(viewModel: LoadingViewModel) {
        self.emit?(viewModel)
    }
}
