//
//  NetworkExtensions.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 06/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import Foundation
import Network

extension IPv4Address {
    
    enum Error: Swift.Error, LocalizedError {
        
        case invalidString
        
        var errorDescription: String? {
            switch self {
            case .invalidString:
                return "Invalid IP address string"
            }
        }
        
        var recoverySuggestion: String? {
            return "Please provide an IP address with a valid format, for example \"192.168.0.1\"."
        }
        
    }
    
    init(_ string: String) throws {
        guard let address = IPv4Address(string) else {
            throw Error.invalidString
        }
        
        self = address
    }
    
}
