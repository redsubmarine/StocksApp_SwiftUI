//
//  DateRangePickerView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import SwiftUI
import StocksAPI

struct DateRangePickerView: View {
    let rangeTypes = ChartRange.allCases
    @Binding var selectedRange: ChartRange
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(rangeTypes) { range in
                    Button(action: {
                        self.selectedRange = range
                    }, label: {
                        Text(range.title)
                            .font(.callout.bold())
                            .padding(8)
                    })
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .background {
                        if range == selectedRange {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.4))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        
    }
}

struct DateRangePickerView_Previews: PreviewProvider {
    
    @State static var dateRange = ChartRange.oneDay
    
    static var previews: some View {
        DateRangePickerView(selectedRange: $dateRange)
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
    }
}
