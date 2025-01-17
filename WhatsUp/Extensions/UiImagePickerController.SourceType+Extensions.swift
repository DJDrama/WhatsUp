//
//  UiImagePickerController.SourceType+Extensions.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/17/25.
//

import Foundation
import UIKit

extension UIImagePickerController.SourceType: Identifiable {
    public var id: Int {
        switch self {
        case .camera:
            return 1
        case .photoLibrary:
            return 2
        case .savedPhotosAlbum:
            return 3
        @unknown default:
            return 4
        }
    }
    
    
}
