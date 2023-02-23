//
//  LoadingStateView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI

struct LoadingStateView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct LoadingStateView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingStateView()
    }
}
