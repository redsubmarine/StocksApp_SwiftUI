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
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
