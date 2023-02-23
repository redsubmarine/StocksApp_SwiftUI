//
//  Stubs.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import Foundation
import StocksAPI

#if DEBUG

extension Ticker {
    static var stubs: [Ticker] = [
        .init(symbol: "AAPL", shortname: "Apple Inc."),
        .init(symbol: "TSLA", shortname: "Tesla."),
        .init(symbol: "NVDA", shortname: "Nvidia Corp."),
        .init(symbol: "AMD", shortname: "Advaned Micro Device"),
    ]
}

extension Quote {
    static var stubs: [Quote] = [
        .init(symbol: "AAPL", regularMarketPrice: 150.43, regularMarketChange: -2.31),
        .init(symbol: "TSLA", regularMarketPrice: 250.43, regularMarketChange: 2.89),
        .init(symbol: "NVDA", regularMarketPrice: 100.13, regularMarketChange: -12.21),
        .init(symbol: "AMD", regularMarketPrice: 70.43, regularMarketChange: 12.55),
    ]
    
    static var stubsDict: [String: Quote] {
        var dict = [String: Quote]()
        stubs.forEach({ dict[$0.symbol] = $0 })
        return dict
    }
}

#endif
