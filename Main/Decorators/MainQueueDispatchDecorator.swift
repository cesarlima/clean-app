//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by MacPro on 15/05/20.
//  Copyright © 2020 br.com.cesarlima. All rights reserved.
//

import Foundation
import Domain


public final class MainQueueDispatchDecorator<T> {
    private let instance:T
    
    public init(_ instance:T) {
        self.instance = instance
    }
    
    public func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}

extension MainQueueDispatchDecorator: AddAccount where T: AddAccount {
    public func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccount.Result) -> Void) {
        instance.add(addAccountModel: addAccountModel) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
