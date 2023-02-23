//
//  ErrorStateView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI

struct ErrorStateView: View {
    let error: String
    var retryCallback: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Text(error)
                if let retryCallback {
                    Button("Retry", action: retryCallback)
                        .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .padding(64)
    }
}

struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorStateView(error: "An Error Occurred")
                .previewDisplayName("Without Retry Button")
            
            ErrorStateView(error: "An Error Occurred", retryCallback: {})
                .previewDisplayName("With Retry Button")
        }
    }
}
