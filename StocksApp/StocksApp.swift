//
//  StocksApp.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI

@main
struct StocksApp: App {
    @StateObject var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainListView()
            }
            .environmentObject(appViewModel)
        }
        
    }
}
