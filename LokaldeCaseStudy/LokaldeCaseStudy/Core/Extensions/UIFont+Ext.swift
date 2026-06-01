//
//  UIFont+Ext.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

extension UIFont {
    
    // MARK: - Font Family Configuration
    
    private static let design: UIFontDescriptor.SystemDesign = .rounded
    
    // MARK: - Helper Function
    private static func systemFont(design: UIFontDescriptor.SystemDesign, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(design) ?? UIFont.systemFont(ofSize: size).fontDescriptor
        return UIFont(descriptor: descriptor, size: size)
    }
    
    // MARK: - Pre-defined Fonts
    static var displayTitle: UIFont {
        return systemFont(design: design, size: 28, weight: .bold)
    }

    static var title: UIFont {
        return systemFont(design: design, size: 28, weight: .semibold)
    }
    
    static var headline: UIFont {
        return systemFont(design: design, size: 17, weight: .semibold)
    }
    
    static var text: UIFont {
        return systemFont(design: design, size: 17, weight: .regular)
    }
    
    static var buttonText: UIFont {
        return systemFont(design: design, size: 17, weight: .bold)
    }
}
