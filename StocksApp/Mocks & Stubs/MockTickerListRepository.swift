//
//  MockTickerListRepository.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import StocksAPI

#if DEBUG
struct MockTickerListRepository: TickerListRepository {
    var stubbedLoad: (() async throws -> [Ticker])!
    
    func save(_ current: [Ticker]) async throws { }
    
    func load() async throws -> [Ticker] {
        try await stubbedLoad()
    }
}

#endif
