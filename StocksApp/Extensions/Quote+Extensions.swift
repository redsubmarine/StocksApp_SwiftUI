//
//  Quote+Extensions.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import Foundation
import StocksAPI

extension Quote {
    var isTrading: Bool {
        marketState == "REGULAR"
    }
    
    var regularPriceText: String? {
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String? {
        guard let text = Utils.format(value: regularMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
    
    var postPriceText: String? {
        Utils.format(value: postMarketPrice)
    }
    
    var postPriceDiffText: String? {
        guard let text = Utils.format(value: postMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
    
    var highText: String {
        Utils.format(value: regularMarketDayHigh) ?? "-"
    }
    
    var openText: String {
        Utils.format(value: regularMarketOpen) ?? "-"
    }
    
    var lowText: String {
        Utils.format(value: regularMarketDayLow) ?? "-"
    }
    
    var volText: String {
        regularMarketVolume?.formatUsingAbbrevation() ?? "-"
    }
    
    var peText: String {
        Utils.format(value: trailingPE) ?? "-"
    }
    
    var mktCapText: String {
        marketCap?.formatUsingAbbrevation() ?? "-"
    }
    
    var fiftyTwoWHText: String {
        Utils.format(value: fiftyTwoWeekHigh) ?? "-"
    }
    
    var fiftyTwoWLText: String {
        Utils.format(value: fiftyTwoWeekLow) ?? "-"
    }
    
    var avgVolText: String {
        averageDailyVolume3Month?.formatUsingAbbrevation() ?? "-"
    }
    
    var yieldText: String { "-" }
    var betaText: String { "-" }
    
    var epsText: String {
        Utils.format(value: epsTrailingTwelveMonths) ?? "-"
    }
    
    var columnItems: [QuoteDetailRowColumnItem] {
        [
            .init(rows: [
                .init(title: "Open", value: openText),
                .init(title: "High", value: highText),
                .init(title: "Low", value: lowText)
            ]),
            .init(rows: [
                .init(title: "Vol", value: volText),
                .init(title: "P/E", value: peText),
                .init(title: "Mkt Cap", value: mktCapText)
            ]),
            .init(rows: [
                .init(title: "52W H", value: fiftyTwoWHText),
                .init(title: "52W L", value: fiftyTwoWLText),
                .init(title: "Avg Vol", value: avgVolText)
            ]),
            .init(rows: [
                .init(title: "Yield", value: yieldText),
                .init(title: "Beta", value: betaText),
                .init(title: "EPS", value: epsText)
            ])
        ]
    }
}
