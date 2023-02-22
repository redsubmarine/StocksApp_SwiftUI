//
//  StocksAppApp.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI
import StocksAPI

@main
struct StocksAppApp: App {
    let stocksAPI = StocksAPI()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        do {
                            let quotes = try await stocksAPI.fetchQuotes(symbols: "AAPL")
                            print("--", quotes)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
        }
    }
}
