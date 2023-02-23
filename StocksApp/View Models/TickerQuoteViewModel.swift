//
//  TickerQuoteViewModel.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import SwiftUI
import StocksAPI

@MainActor
class TickerQuoteViewModel: ObservableObject {
    @Published var phase = FetchPhase<Quote>.initial
    var quote: Quote? { phase.value }
    var error: Error? { phase.error }
    
    let ticker: Ticker
    let stocksAPI: AppStocksAPI
    
    init(ticker: Ticker, stocksAPI: AppStocksAPI = StocksAPI()) {
        self.ticker = ticker
        self.stocksAPI = stocksAPI
    }
    
    func fetchQuotes() async {
        phase = .fetching
        
        do {
            let response = try await stocksAPI.fetchQuotes(symbols: ticker.symbol)
            if let quote = response.first {
                phase = .success(quote)
            } else {
                phase = .empty
            }
        } catch {
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
