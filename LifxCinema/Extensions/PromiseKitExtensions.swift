//
//  PromiseKitExtensions.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 06/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import Foundation
import PromiseKit

enum PMKTimeoutError: Swift.Error, LocalizedError {
    
    case timeout(seconds: TimeInterval)
    
    var errorDescription: String? {
        switch self {
        case .timeout(let seconds):
            return "Timeout after \(seconds) seconds"
        }
    }
    
}

extension Promise {
    
    func timeout(seconds: TimeInterval) -> Promise<T> {
        return race(
            self,
            after(seconds: seconds).map {
                throw PMKTimeoutError.timeout(seconds: seconds)
            }
        )
    }
    
}
