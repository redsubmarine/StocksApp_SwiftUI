//
//  MockStubsAPI.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import StocksAPI

#if DEBUG
struct MockStocksAPI: AppStocksAPI {
    
    var stubbedSearchTickersCallback: (() async throws -> [Ticker])!
    
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        try await stubbedSearchTickersCallback()
    }
    
    var stubbedFetchQuotesCallback: (() async throws -> [Quote])!
    func fetchQuotes(symbols: String) async throws -> [Quote] {
        try await stubbedFetchQuotesCallback()
    }
}

#endif
