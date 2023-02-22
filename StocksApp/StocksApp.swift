//
//  StocksApp.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI
import StocksAPI

@main
struct StocksApp: App {
    let stocksAPI = StocksAPI()
    
    var body: some Scene {
        WindowGroup {
            MainListView()
        }
    }
}
