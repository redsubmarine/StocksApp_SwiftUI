//
//  AppViewModel.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI
import StocksAPI

@MainActor
class AppViewModel: ObservableObject {
    @Published var tickers: [Ticker] = []
    
    var titleText = "Stocks"
    @Published var subtitleText: String
    var emptyTickersText = "Search & add symbol to see stock quotes"
    var attributionText = "Powered by Yahoo! finance API"
    
    private let subtitleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
    
    init() {
        subtitleText = subtitleDateFormatter.string(from: Date())
    }
    
    func removeTickers(atOffsets offsets: IndexSet) {
        tickers.remove(atOffsets: offsets)
    }
    
    func isAddedToMyTickers(ticker: Ticker) -> Bool {
        tickers.first { $0.symbol == ticker.symbol } != nil
    }
    
    func toggleTicker(_ ticker: Ticker) {
        if isAddedToMyTickers(ticker: ticker) {
            removeFromMyTickers(ticker: ticker)
        } else {
            addToMyTickers(ticker: ticker)
        }
    }
    
    private func addToMyTickers(ticker: Ticker) {
        tickers.append(ticker)
    }
    
    private func removeFromMyTickers(ticker: Ticker) {
        guard let index = tickers.firstIndex(where: { $0.symbol == ticker.symbol }) else { return }
        tickers.remove(at: index)
    }
    
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
}
