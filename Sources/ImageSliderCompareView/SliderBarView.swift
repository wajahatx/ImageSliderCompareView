//
//  File.swift
//  ImageSliderCompareView
//
//  Created by Wajahat on 01/08/2025.
//

import Foundation
import SwiftUI
struct SliderBarView: View {
    @State var config: SliderConfig
    var body: some View {
        ZStack(alignment: .center){
            if !config.animated{
                GeometryReader { geo in
                    VStack{
                        Spacer()
                        Circle()
                            .frame(width: 37, height: 37)
                            .foregroundStyle(config.sliderColor)
                            .overlay(content: {
                                HStack(spacing: 2) {
                                    Image(systemName: "chevron.left")
                                        .renderingMode(.template)
                                        .imageScale(.small)
                                        .foregroundColor(config.sliderIndicatorColor)
                                    Image(systemName: "chevron.right")
                                        .renderingMode(.template)
                                        .imageScale(.small)
                                        .foregroundColor(config.sliderIndicatorColor)
                                }
                            })
                            .offset(x : -(17))
                            .disabled(true)
                        Spacer()
                            .frame(height: geo.size.height/4)
                    }
                }
            }
            
        }
        .frame(minWidth: config.width, maxWidth: config.width, maxHeight: .infinity)
        .background(config.sliderColor)
    }
}
