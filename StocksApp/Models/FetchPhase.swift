//
//  FetchPhase.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import Foundation

enum FetchPhase<V> {
    case initial
    case fetching
    case success(V)
    case failure(Error)
    case empty
    
    var value: V? {
        if case let .success(v) = self {
            return v
        }
        return nil
    }
    
    var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        return nil
    }
}
