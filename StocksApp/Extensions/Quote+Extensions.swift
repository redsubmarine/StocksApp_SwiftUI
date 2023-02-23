//
//  Quote+Extensions.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import Foundation
import StocksAPI

extension Quote {
    var regularPriceText: String? {
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String? {
        guard let text = Utils.format(value: regularMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
}
