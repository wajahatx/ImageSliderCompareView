//
//  File.swift
//  ImageSliderCompareView
//
//  Created by Wajahat on 01/08/2025.
//

import Foundation
import SwiftUI
import UIKit
public struct SliderConfig {
    public let contentType : ContentMode
    public let width: CGFloat
    public let sliderColor: Color
    public let start: CGFloat
    public let end: CGFloat
    public let animated: Bool
    public let duration: TimeInterval
    public let sliderIndicatorColor: Color
    public let isHelpingLabelHidden: Bool
    public let imageCornerRadius: CGFloat
    
    
    public init(
        contentType : ContentMode = .fit,
        width: CGFloat = 2,
        start: CGFloat = 0.05,
        end: CGFloat = 0.95,
        sliderColor: Color = UIColor.label.swiftUiColor,
        animated: Bool = true,
        duration: TimeInterval = 2,
        sliderIndicatorColor: Color = UIColor.systemBackground.swiftUiColor,
        isHelpingLabelHidden: Bool = false,
        imageCornerRadius: CGFloat = 0
        
    ) {
        self.width = width
        self.start = start
        self.end = end
        self.sliderColor = sliderColor
        self.animated = animated
        self.duration = duration
        self.contentType = contentType
        self.sliderIndicatorColor = sliderIndicatorColor
        self.isHelpingLabelHidden = isHelpingLabelHidden
        self.imageCornerRadius = imageCornerRadius
    }
}
