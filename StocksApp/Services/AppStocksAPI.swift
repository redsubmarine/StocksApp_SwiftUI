//
//  AppStocksAPI.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import StocksAPI

protocol AppStocksAPI {
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
    func fetchChartData(symbol: String, range: ChartRange) async throws -> ChartData?
}

extension StocksAPI: AppStocksAPI {
    
}
