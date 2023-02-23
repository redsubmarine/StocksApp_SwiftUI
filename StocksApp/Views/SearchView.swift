//
//  SearchView.swift
//  StocksApp
//
//  Created by 레드 on 2023/02/23.
//

import SwiftUI
import StocksAPI

struct SearchView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var quotesViewModel = QuotesViewModel()
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        List(searchViewModel.tickers) { ticker in
            TickerListRowView(data:
                    .init(
                        symbol: ticker.symbol,
                        name: ticker.shortname,
                        price: quotesViewModel.priceForTicker(ticker),
                        type: .search(
                            isSaved: appViewModel.isAddedToMyTickers(ticker: ticker),
                            onButtonTapped: {
                                Task { @MainActor in
                                    appViewModel.toggleTicker(ticker)
                                }
                            }
                        )
                    )
            )
//            .contentShape(Rectangle())
//            .onTapGesture { }
        }
        .background(.white)
        .listStyle(.plain)
        .refreshable {
            await quotesViewModel.fetchQuotes(tickers: searchViewModel.tickers)
        }
        .task(id: searchViewModel.tickers, {
            await quotesViewModel.fetchQuotes(tickers: searchViewModel.tickers)
        })
        .overlay {
            listSearchOveray
        }
    }
    
    @ViewBuilder
    private var listSearchOveray: some View {
        switch searchViewModel.phase {
        case let .failure(error):
            ErrorStateView(error: error.localizedDescription) {
                Task {
                    await searchViewModel.searchTickers()
                }
            }
        case .empty:
            EmptyStateView(text: searchViewModel.emptyListText)
        case .fetching:
            LoadingStateView()
        default:
            EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    
    @StateObject static var stubbedSearchViewModel: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = {
            Ticker.stubs
        }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var emptySearchViewModel: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = {
            []
        }
        return SearchViewModel(query: "Theranos", stocksAPI: mock)
    }()
    
    @StateObject static var loadingSearchViewModel: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = {
            await withCheckedContinuation { _ in }
        }
        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var errorSearchViewModel: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallback = { throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An Error has been occured"]) }

        return SearchViewModel(query: "Apple", stocksAPI: mock)
    }()
    
    @StateObject static var appViewModel: AppViewModel = {
        var mock = MockTickerListRepository()
        mock.stubbedLoad = { Array(Ticker.stubs.prefix(upTo: 2)) }
        let viewModel = AppViewModel(repository: mock)
        
        return viewModel
    }()
    
    static var quotesViewModel: QuotesViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedFetchQuotesCallback = { Quote.stubs }
        return QuotesViewModel(stocksAPI: mock)
    }()
    
    static var previews: some View {
        Group {
            NavigationStack {
                SearchView(quotesViewModel: quotesViewModel, searchViewModel: stubbedSearchViewModel)
            }
            .searchable(text: $stubbedSearchViewModel.query)
            .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(quotesViewModel: quotesViewModel, searchViewModel: emptySearchViewModel)
            }
            .searchable(text: $emptySearchViewModel.query)
            .previewDisplayName("Empty Results")
            
            NavigationStack {
                SearchView(quotesViewModel: quotesViewModel, searchViewModel: loadingSearchViewModel)
            }
            .searchable(text: $loadingSearchViewModel.query)
            .previewDisplayName("Loading State")
            
            NavigationStack {
                SearchView(quotesViewModel: quotesViewModel, searchViewModel: errorSearchViewModel)
            }
            .searchable(text: $errorSearchViewModel.query)
            .previewDisplayName("Error State")
            
        }
        .environmentObject(appViewModel)
    }
}
