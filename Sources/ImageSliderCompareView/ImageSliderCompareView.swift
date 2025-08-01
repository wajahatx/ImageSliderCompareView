// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Foundation
import CachedAsyncImage
public struct ImageSliderCompareView: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1
    @State private var slider: CGFloat = 0.5
    @State private var dragOffset: CGSize = .zero
    @State private var lastDragPosition: CGSize = .zero
    @State private var isMovingForward = true
    @State private var shouldAnimate = false
    @State var timer: Timer?
    @State var config: SliderConfig
    let before: URL?
    let after: URL?
    
    public init(before: URL?, after: URL?, config: SliderConfig = SliderConfig()) {
        self.config = config
        self.before = before
        self.after = after
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    CachedAsyncImage(url: after) { image in
                        image
                            .resizable()
                            .cornerRadius(config.imageCornerRadius)
                            .overlay(alignment: .topTrailing) {
                                if !config.animated && !config.isHelpingLabelHidden {
                                    ZStack {
                                        Text("After")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .foregroundStyle(UIColor.label.swiftUiColor)
                                            .padding(.horizontal,8)
                                        
                                    }
                                    .frame(height: 24)
                                    .background(
                                        .thinMaterial)
                                    .cornerRadius(100)
                                    .padding([.trailing, .top], 16)
                                }
                            }
                            .clipped()
                            .scaleEffect(scale)
                          

                    } placeholder: {
                        ProgressView()
                    }
                    .offset(x: dragOffset.width, y: dragOffset.height)
                    .aspectRatio(contentMode: config.contentType)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .zIndex(1)
                    
                    CachedAsyncImage(url: before) { image in
                        image
                            .resizable()
                            .cornerRadius(config.imageCornerRadius)
                            .zIndex(1)
                            .overlay(alignment: .topLeading) {
                                if !config.animated && !config.isHelpingLabelHidden {
                                    ZStack {
                                        Text("Before")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .foregroundStyle(UIColor.label.swiftUiColor)
                                            .padding(.horizontal,8)
                                    }
                                    .frame(height: 24)
                                    .background(
                                        .thinMaterial)
                                    .cornerRadius(100)
                                    .padding([.leading, .top], 16)
                                }
                            }
                            .clipped()
                            .scaleEffect(scale)
                          

                    } placeholder: {
                        ProgressView()
                    }
                    .offset(x: dragOffset.width, y: dragOffset.height)
                    .aspectRatio(contentMode: config.contentType)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .zIndex(1)
                    .onAppear(perform: startAnimation)
                    .mask(
                        Rectangle()
                            .frame(width: geometry.size.width * slider * 2)
                            .ignoresSafeArea()
                            .offset(x: -geometry.size.width / 2)
                    )
                    SliderBarView(config: config)
                        .offset(x: geometry.size.width * self.slider)
                        .zIndex(2)
                        .gesture(DragGesture()
                            .onChanged({ value in
                                let newSliderValue = min(max(0.1, value.location.x / geometry.size.width), 0.9)
                                slider = newSliderValue
                            })
                        )
                }
            }
            .background(.clear)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let horizontalBoundary = max(0, (geometry.size.width * scale - geometry.size.width) / 2)
                        let verticalBoundary = max(0, (geometry.size.height * scale - geometry.size.height) / 2)
                        let newOffset = CGSize(width: lastDragPosition.width + gesture.translation.width,
                                               height: lastDragPosition.height + gesture.translation.height)
                        if abs(newOffset.width) > horizontalBoundary {
                            dragOffset.width = newOffset.width.sign == .minus ? -horizontalBoundary : horizontalBoundary
                        } else {
                            dragOffset.width = newOffset.width
                        }
                        if abs(newOffset.height) > verticalBoundary {
                            dragOffset.height = newOffset.height.sign == .minus ? -verticalBoundary : verticalBoundary
                        } else {
                            dragOffset.height = newOffset.height
                        }
                    }
                    .onEnded { _ in
                        lastDragPosition = dragOffset
                    }
            )
            .onTapGesture(count: 2, perform: {
                if scale == 1 {
                    withAnimation {
                        scale = 2
                    }
                } else {
                    withAnimation {
                        scale = 1
                        dragOffset = .zero
                        lastDragPosition = .zero
                    }
                }
            })
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        withAnimation {
                            let newScale = scale * value / lastScaleValue

                            if newScale >= 1 && newScale <= 3 {
                                scale = newScale
                            } else if newScale > 3 {
                                scale = 3
                            }

                            lastScaleValue = value
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            if scale < 2.0 {
                                scale = 1
                                dragOffset = .zero
                                lastDragPosition = .zero
                            } else if scale > 3 {
                                scale = 3
                            }
                            lastScaleValue = 1
                        }
                    }
            )
            .disabled(config.animated)
        }
    }
    
    private func resetImageState() {
        withAnimation {
            scale = 1
        }
    }
    
    private func startAnimation() {
        if config.animated {
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                Task { @MainActor in
                    if slider.rounded(decimalPlaces: 2) == config.start {
                        isMovingForward = true
                    } else if slider.rounded(decimalPlaces: 2) == config.end {
                        isMovingForward = false
                    }
                    if isMovingForward {
                        withAnimation {
                            slider += 0.005
                        }
                    } else {
                        withAnimation {
                            slider -= 0.005
                        }
                    }
                }
            }
        }
    }
}

