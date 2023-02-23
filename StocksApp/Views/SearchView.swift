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
                            onButtonTapped: { appViewModel.toggleTicker(ticker) }
                        )
                    )
            )
            .contentShape(Rectangle())
            .onTapGesture { }
        }
        .listStyle(.plain)
        .overlay {
            listSearchOveray
        }
    }
    
    @ViewBuilder
    private var listSearchOveray: some View {
        switch searchViewModel.phase {
        case let .failure(error):
            ErrorStateView(error: error.localizedDescription) {}
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
        let viewModel = SearchViewModel()
        viewModel.phase = .success(Ticker.stubs)
        return viewModel
    }()
    
    @StateObject static var emptySearchViewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.query = "Theranos"
        viewModel.phase = .empty
        return viewModel
    }()
    
    @StateObject static var loadingSearchViewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.phase = .fetching
        return viewModel
    }()
    
    @StateObject static var errorSearchViewModel: SearchViewModel = {
        let viewModel = SearchViewModel()
        viewModel.phase = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An Error has been occured"]))
        return viewModel
    }()
    
    @StateObject static var appViewModel: AppViewModel = {
        let viewModel = AppViewModel()
        viewModel.tickers = Array(Ticker.stubs.prefix(upTo: 2))
        return viewModel
    }()
    
    static var quotesViewModel: QuotesViewModel = {
        let viewModel = QuotesViewModel()
        viewModel.quotesDict = Quote.stubsDict
        return viewModel
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
