//
//  Image+Extensions.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/17/25.
//

import Foundation
import SwiftUI

extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
