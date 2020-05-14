
//
//  Storyboarded.swift
//  UI
//
//  Created by MacPro on 14/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import UIKit

public protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    public static func instantiate() -> Self {
        let viewControllerName = String(describing: self)
        let storyBoardName = viewControllerName.components(separatedBy: "ViewController")[0]
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: storyBoardName, bundle: bundle)
        return storyboard.instantiateViewController(identifier: viewControllerName) as! Self
    }
}
