//
//  MainListView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI
import StocksAPI

struct MainListView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
