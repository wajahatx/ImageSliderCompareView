//
//  File.swift
//  ImageSliderCompareView
//
//  Created by Wajahat on 01/08/2025.
//

import Foundation
import UIKit
import SwiftUI
extension CGFloat {
    func rounded(decimalPlaces: Int) -> CGFloat {
        let multiplier = pow(10.0, CGFloat(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}


public extension UIColor{
    var swiftUiColor : Color {
        get{
            Color(uiColor: self)
        }
    }
}
