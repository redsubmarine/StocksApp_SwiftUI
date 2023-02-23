//
//  SearchViewModel.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import Combine
import SwiftUI
import StocksAPI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var phase: FetchPhase<[Ticker]> = .initial
    
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var tickers: [Ticker] { phase.value ?? [] }
    var error: Error? { phase.error }
    var isSearching: Bool { !trimmedQuery.isEmpty }
    
    var emptyListText: String {
        "Symbols not found for\n\"\(query)\""
    }
}
