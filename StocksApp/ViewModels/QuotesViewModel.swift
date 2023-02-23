//
//  QuotesViewModel.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import SwiftUI
import StocksAPI

@MainActor
class QuotesViewModel: ObservableObject {
    @Published var quotesDict: [String: Quote] = [:]
    private let stocksAPI: AppStocksAPI
    
    init(stocksAPI: AppStocksAPI = StocksAPI()) {
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuotes(tickers: [Ticker]) async {
        guard !tickers.isEmpty else { return }
        do {
            let symbols = tickers.map({ $0.symbol }).joined(separator: ",")
            let quotes = try await stocksAPI.fetchQuotes(symbols: symbols)
            var dict = [String: Quote]()
            quotes.forEach({ dict[$0.symbol] = $0 })
            self.quotesDict = dict
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
