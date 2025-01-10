//
//  String+Extensions.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/10/25.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
