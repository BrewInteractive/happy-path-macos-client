//
//  Font.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 13.09.2023.
//

import Foundation
import SwiftUI

enum FigtreeFontWeight: String {
    case black,
         blackItalic,
         bold,
         boldItalic,
         extraBold,
         extraBoldItalic,
         italic,
         light,
         lightItalic,
         medium,
         mediumItalic,
         regular,
         semiBold,
         semiBoldItalic
    
    var value: String {
        return "Figtree-\(self.rawValue.capitalizedFirstletter)"
    }
}

enum RobotoFontWeight: String {
    case regular
    
    var value: String {
        return "Roboto-\(self.rawValue.capitalizedFirstletter)"
    }
}

extension Font {
    static func figtree(size: CGFloat = 14, weight: FigtreeFontWeight = .regular) -> Font {
        Font.custom(weight.value, size: size)
    }
    
    static func roboto(size: CGFloat = 14, weight: RobotoFontWeight = .regular) -> Font {
        Font.custom(weight.value, size: size)
    }
}
