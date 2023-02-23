//
//  MainListView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/22.
//

import SwiftUI
import StocksAPI

struct MainListView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var quotesViewModel = QuotesViewModel()
    @StateObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        tickerListView
            .listStyle(.plain)
            .overlay {
                overlayView
            }
            .toolbar {
                titleToolbar
                attributionToolbar
            }
            .searchable(text: $searchViewModel.query)
            .refreshable {
                await quotesViewModel.fetchQuotes(tickers: appViewModel.tickers)
            }
            .sheet(item: $appViewModel.selectedTicker) {
                StockTickerView(chartViewModel: ChartViewModel(ticker: $0, apiService: quotesViewModel.stocksAPI), quoteViewModel: .init(ticker: $0, stocksAPI: quotesViewModel.stocksAPI))
                    .presentationDetents([.height(560)])
            }
            .task(id: appViewModel.tickers) {
                await quotesViewModel.fetchQuotes(tickers: appViewModel.tickers)
            }
    }
    
    private var tickerListView: some View {
        List {
            ForEach(appViewModel.tickers) { ticker in
                TickerListRowView(data: .init(symbol: ticker.symbol, name: ticker.shortname, price: quotesViewModel.priceForTicker(ticker), type: .main))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        appViewModel.selectedTicker = ticker
                    }
            }
            .onDelete { appViewModel.removeTickers(atOffsets: $0) }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        if appViewModel.tickers.isEmpty {
            EmptyStateView(text: appViewModel.emptyTickersText)
        }
        
        if searchViewModel.isSearching {
            SearchView(searchViewModel: searchViewModel)
        }
    }
    
    private var titleToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            VStack(alignment: .leading, spacing: -4) {
                Text(appViewModel.titleText)
                Text(appViewModel.subtitleText)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            .font(.title2.weight(.heavy))
            .padding(.bottom)
        }
    }
    
    private var attributionToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button(action: {
                    appViewModel.openYahooFinance()
                }, label: {
                    Text(appViewModel.attributionText)
                        .font(.caption.weight(.heavy))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                })
                .buttonStyle(.plain)
                Spacer()
            }
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    @StateObject static var appViewModel: AppViewModel = {
        var mock = MockTickerListRepository()
        mock.stubbedLoad = { Ticker.stubs }
        let viewModel = AppViewModel(repository: mock)
        
        return viewModel
    }()
    
    @StateObject static var emptyAppViewModel: AppViewModel = {
        var mock = MockTickerListRepository()
        mock.stubbedLoad = { [] }
        let viewModel = AppViewModel(repository: mock)
        
        return viewModel
    }()
    
    static var quotesViewModel: QuotesViewModel = {
        let viewModel = QuotesViewModel()
        viewModel.quotesDict = Quote.stubsDict
        return viewModel
    }()
    
    static var searchViewModel: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { Ticker.stubs }
        return SearchViewModel(stocksAPI: mock)
    }()
    
    static var previews: some View {
        Group {
            NavigationStack {
                MainListView(quotesViewModel: quotesViewModel, searchViewModel: searchViewModel)
            }
            .environmentObject(appViewModel)
            .previewDisplayName("With Tickers")
            
            NavigationStack {
                MainListView(quotesViewModel: quotesViewModel, searchViewModel: searchViewModel)
            }
            .environmentObject(emptyAppViewModel)
            .previewDisplayName("With Empty Tickers")
        }
    }
}
