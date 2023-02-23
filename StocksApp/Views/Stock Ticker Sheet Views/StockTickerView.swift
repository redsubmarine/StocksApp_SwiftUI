//
//  StockTickerView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import SwiftUI
import StocksAPI

struct StockTickerView: View {
    
    @StateObject var chartViewModel: ChartViewModel
    @StateObject var quoteViewModel: TickerQuoteViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
                .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
                .padding(.horizontal)
            
            scrollView
        }
        .padding(.top)
        .background(Color(uiColor: .systemBackground))
        .task(id: chartViewModel.selectedRange.rawValue) {
            if quoteViewModel.quote == nil {
                await quoteViewModel.fetchQuotes()
            }
            await chartViewModel.fetchData()
        }
    }

    private var scrollView: some View {
        ScrollView {
            priceDiffRowView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
                .padding(.horizontal)
            
            Divider()
            
            ZStack {
                DateRangePickerView(selectedRange: $chartViewModel.selectedRange)
                    .opacity(chartViewModel.selectedXOpacity)
                
                Text(chartViewModel.selectedXDateText)
                    .font(.headline)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
            }
            
            Divider()
            
            chartView
                .padding(.horizontal)
                .frame(maxWidth: .infinity, minHeight: 220)
            
            Divider()
                .padding([.horizontal, .top])
            
            quoteDetailRowView
                .frame(maxWidth: .infinity, minHeight: 80)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var chartView: some View {
        switch chartViewModel.fetchPhase {
        case .fetching:
            LoadingStateView()
        case let .success(data):
            ChartView(data: data, viewModel: chartViewModel)
        case let .failure(error):
            ErrorStateView(error: "Chart: \(error.localizedDescription)")
                .padding(.horizontal)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var quoteDetailRowView: some View {
        switch quoteViewModel.phase {
        case .fetching: LoadingStateView()
        case let .failure(error): ErrorStateView(error: "Quote: \(error.localizedDescription)")
                .padding(.horizontal)
        case let .success(quote):
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(quote.columnItems) { item in
                        QuoteDetailRowColumnView(item: item)
                    }
                }
                .padding(.horizontal)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
            }
            
        default:
            EmptyView()
        }
    }
    
    private var priceDiffRowView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let quote = quoteViewModel.quote {
                HStack {
                    if quote.isTrading,
                       let price = quote.regularPriceText,
                       let diff = quote.regularDiffText {
                        priceDiffStackView(price: price, diff: diff, caption: nil)
                    } else {
                        if let atCloseText = quote.regularPriceText,
                           let atCloseDiffText = quote.regularDiffText {
                            priceDiffStackView(price: atCloseText, diff: atCloseDiffText, caption: "At Close")
                        }
                        
                        if let afterHourText = quote.postPriceText,
                           let afterHourDiffText = quote.postPriceDiffText {
                            priceDiffStackView(price: afterHourText, diff: afterHourDiffText, caption: "After Hours")
                        }
                    }
                    Spacer()
                }
            }
            exchangeCurrencyView
        }
    }
    
    private var exchangeCurrencyView: some View {
        HStack(spacing: 4) {
            if let exchange = quoteViewModel.ticker.exchDisp {
                Text(exchange)
            }
            
            if let currency = quoteViewModel.quote?.currency {
                Text("·")
                Text(currency)
            }
        }
        .font(.subheadline.weight(.semibold))
        .foregroundColor(Color(uiColor: .secondaryLabel))
    }
    
    private func priceDiffStackView(price: String, diff: String, caption: String?) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline, spacing: 16) {
                Text(price)
                    .font(.headline.bold())
                Text(diff)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(diff.hasPrefix("-") ? .red : .green)
            }
            
            if let caption {
                Text(caption)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
    }

    private var headerView: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(quoteViewModel.ticker.symbol)
                .font(.title.bold())
            if let shortname = quoteViewModel.ticker.shortname {
                Text(shortname)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            Spacer()
            closeButton
        }
    }
    
    private var closeButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Circle()
                .frame(width: 36, height: 36)
                .foregroundColor(.gray.opacity(0.1))
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 18).bold())
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
        })
    }
}

struct StockTickerView_Previews: PreviewProvider {
    static var tradingStubsQuoteViewModel: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(isTrading: true)]
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    static var closedStubsQuoteViewModel: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            [Quote.stub(isTrading: false)]
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    static var loadingStubsQuoteViewModel: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            await withCheckedContinuation { _ in
                
            }
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    static var errorStubsQuoteViewModel: TickerQuoteViewModel = {
        var mockAPI = MockStocksAPI()
        mockAPI.stubbedFetchQuotesCallback = {
            throw NSError(domain: "error", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "An error has been occurred"
            ])
        }
        return TickerQuoteViewModel(ticker: .stub, stocksAPI: mockAPI)
    }()
    
    static var chartViewModel: ChartViewModel {
        .init(ticker: .stub, apiService: MockStocksAPI())
    }
    
    static var previews: some View {
        Group {
            StockTickerView(chartViewModel: chartViewModel, quoteViewModel: tradingStubsQuoteViewModel)
                .previewDisplayName("Trading")
                .frame(height: 700)
            
            StockTickerView(chartViewModel: chartViewModel, quoteViewModel: closedStubsQuoteViewModel)
                .previewDisplayName("Closed")
                .frame(height: 700)
            
            StockTickerView(chartViewModel: chartViewModel, quoteViewModel: loadingStubsQuoteViewModel)
                .previewDisplayName("Loading")
                .frame(height: 700)
            
            StockTickerView(chartViewModel: chartViewModel, quoteViewModel: errorStubsQuoteViewModel)
                .previewDisplayName("Error")
                .frame(height: 700)
        }
        .previewLayout(.sizeThatFits)
    }
}
