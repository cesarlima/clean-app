//
//  LoadingView.swift
//  Presentation
//
//  Created by MacPro on 06/04/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation

public protocol LoadingView {
    func display(viewModel:LoadingViewModel)
}

public struct LoadingViewModel:Equatable {
    public var isLoading:Bool
    
    public init(isLoading:Bool) {
        self.isLoading = isLoading
    }
}
