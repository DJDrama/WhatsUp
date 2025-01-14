//
//  AppState.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import Foundation

enum Route: Hashable {
    case main
    case login
    case signup
}

class AppState: ObservableObject {
    @Published var routes: [Route] = []
}
