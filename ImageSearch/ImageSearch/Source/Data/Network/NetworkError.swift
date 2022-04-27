//
//  NetworkError.swift
//  ImageSearch
//
//  Created by yongmin lee on 4/26/22.
//

import Foundation

enum NetworkError : Error {
    case client
    case server
}

extension NetworkError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .client:
            return "400 Network client error"
        case .server:
            return "500 Network server error"
        }
    }
}
