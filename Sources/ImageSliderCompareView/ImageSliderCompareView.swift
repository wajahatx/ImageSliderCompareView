// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Foundation
import CachedAsyncImage

public enum ImageSource {
    case url(URL?)
    case image(UIImage?)
}

#Preview {
    ImageSliderCompareView(before: URL(string: "https://1817831052.rsc.cdn77.org/appStuff/retake/reshot-new%20before/b-male/beforenm_2.webp")!, after: URL(string: "https://cdn.reshoot.imagine.art/after/after_5.webp")! , config: .init(animated : false, isHelpingLabelHidden : true))
}

struct ImageContentView: View {
    let imageSource: ImageSource
    let label: String
    let labelAlignment: Alignment
    let config: SliderConfig
    let scale: CGFloat
    let dragOffset: CGSize
    let geometry: GeometryProxy
    @Binding var maxSize: CGSize
    var body: some View {
        Group {
            switch imageSource {
            case .url(let url):
                CachedAsyncImage(url: url) { image in
                    configuredImage(image)
                } placeholder: {
                    ProgressView()
                }
            case .image(let uiImage):
                if let uiImage = uiImage {
                    configuredImage(Image(uiImage: uiImage))
                } else {
                    ProgressView()
                }
            }
        }
    }
    
    @ViewBuilder
    private func configuredImage(_ image: Image) -> some View {
        image
            .resizable()
            .cornerRadius(config.imageCornerRadius)
            .overlay(alignment: labelAlignment) {
                if !config.animated && !config.isHelpingLabelHidden {
                    ZStack {
                        Text(label)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(UIColor.label.swiftUiColor)
                            .padding(.horizontal, 8)
                    }
                    .frame(height: 24)
                    .background(.thinMaterial)
                    .cornerRadius(100)
                    .padding([.trailing, .top], 16)
                }
            }
            .background(
                GeometryReader { geo in
                        Color.clear
                        .onAppear(perform: {
                            maxSize = CGSize(width: max(maxSize.width, geo.size.width), height: max(maxSize.height, geo.size.height))
                        })
                    }
            )
            .clipped()
            .scaleEffect(scale)
            .offset(x: dragOffset.width, y: dragOffset.height)
            .aspectRatio(contentMode: config.contentType)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
}

public struct ImageSliderCompareView: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1
    @State private var slider: CGFloat = 0.5
    @State private var dragOffset: CGSize = .zero
    @State private var lastDragPosition: CGSize = .zero
    @State private var isMovingForward = true
    @State private var shouldAnimate = false
    @State var timer: Timer?
    @State var maxSize: CGSize = .zero
    @State var config: SliderConfig
    let beforeSource: ImageSource
    let afterSource: ImageSource
    
    // MARK: - Initializers
    
    // URL-based initializer (existing)
    public init(before: URL?, after: URL?, config: SliderConfig = SliderConfig()) {
        self.config = config
        self.beforeSource = .url(before)
        self.afterSource = .url(after)
    }
    
    // UIImage-based initializer
    public init(beforeImage: UIImage?, afterImage: UIImage?, config: SliderConfig = SliderConfig()) {
        self.config = config
        self.beforeSource = .image(beforeImage)
        self.afterSource = .image(afterImage)
    }
    
    // Mixed initializer (before: UIImage, after: URL)
    public init(beforeImage: UIImage?, after: URL?, config: SliderConfig = SliderConfig()) {
        self.config = config
        self.beforeSource = .image(beforeImage)
        self.afterSource = .url(after)
    }
    
    // Mixed initializer (before: URL, after: UIImage)
    public init(before: URL?, afterImage: UIImage?, config: SliderConfig = SliderConfig()) {
        self.config = config
        self.beforeSource = .url(before)
        self.afterSource = .image(afterImage)
    }
    
    // ImageSource-based initializer (most flexible)
    public init(beforeSource: ImageSource, afterSource: ImageSource, config: SliderConfig = SliderConfig()) {
        self.config = config
        self.beforeSource = beforeSource
        self.afterSource = afterSource
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    // After image
                    ImageContentView(
                        imageSource: afterSource,
                        label: "After",
                        labelAlignment: .topTrailing,
                        config: config,
                        scale: scale,
                        dragOffset: dragOffset,
                        geometry: geometry, maxSize: $maxSize
                    )
                    
                    .zIndex(1)
                    
                    // Before image
                    ImageContentView(
                        imageSource: beforeSource,
                        label: "Before",
                        labelAlignment: .topLeading,
                        config: config,
                        scale: scale,
                        dragOffset: dragOffset,
                        geometry: geometry, maxSize: $maxSize
                    )
//
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
        .frame(width: maxSize.width > 0 ? maxSize.width : .infinity , height: maxSize.height > 0 ? maxSize.height : .infinity)
       
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
