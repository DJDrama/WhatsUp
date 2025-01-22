//
//  AppState.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import Foundation

enum LoadingState: Hashable, Identifiable {
    case idle
    case loading(String)
    
    var id: Self {
        return self
    }
}

enum Route: Hashable {
    case main
    case login
    case signup
}

class AppState: ObservableObject {
    @Published var routes: [Route] = []
    @Published var loadingState: LoadingState = .idle
    @Published var errorWrapper: ErrorWrapper? // optional - there might be no error~!
}
