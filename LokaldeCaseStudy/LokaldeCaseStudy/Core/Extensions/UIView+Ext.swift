//
//  UIView+Ext.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

extension UIView {
    func makeCircular() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
