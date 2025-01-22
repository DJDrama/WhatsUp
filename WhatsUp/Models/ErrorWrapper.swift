//
//  ErrorWrapper.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/22/25.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}
