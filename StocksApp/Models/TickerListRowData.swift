//
//  TickerListRowData.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import Foundation

typealias PriceChange = (price: String, change: String)

struct TickerListRowData {
    enum RowType {
        case main
        case search(isSaved: Bool, onButtonTapped: () -> Void)
    }
    
    let symbol: String
    let name: String?
    let price: PriceChange?
    let type: RowType
}
