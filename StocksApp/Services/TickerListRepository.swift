//
//  TickerListRepository.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import Foundation
import StocksAPI

protocol TickerListRepository {
    func save(_ current: [Ticker]) async throws
    func load() async throws -> [Ticker]
}


class TickerPlistRepository: TickerListRepository {
    private var saved: [Ticker]?
    private let filename: String
    
    private var url: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(component: "\(filename).plist")
    }
    
    init(filename: String = "my_tickers") {
        self.filename = filename
    }
    
    func save(_ current: [Ticker]) async throws {
        if let saved, saved == current {
            return
        }
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        
        let data = try encoder.encode(current)
        try data.write(to: url, options: [.atomic])
        self.saved = current
    }
    
    func load() async throws -> [Ticker] {
        let data = try Data(contentsOf: url)
        
        let current = try PropertyListDecoder().decode([Ticker].self, from: data)
        saved = current
        return current
    }
}
