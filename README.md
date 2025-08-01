
# 📷 ImageSliderCompareView

A lightweight SwiftUI package that lets users **compare two images interactively** with a slider. Perfect for showcasing before/after effects, AI-enhanced images, or visual changes over time. Supports **pinch-to-zoom**, **drag**, and **animated transitions**.



## 🧰 Features

- 🖼️ Compare images side-by-side using a slider
- 📱 Smooth zoom and pan gestures
- 🔁 Optional slider animation
- 🎯 Fully customizable through `SliderConfig`
- 🧵 Lightweight and easy to integrate

---

## 📦 Installation

### Using Swift Package Manager

1. In Xcode, go to **File > Add Packages**
2. Paste this URL in the search bar:
3. Choose the latest version and add it to your target.

---

## 🔧 Usage

```swift
import ImageSliderCompareView

struct ContentView: View {
    var body: some View {
        ImageSliderCompareView(
            before: URL(string: "https://yourserver.com/before.jpg"),
            after: URL(string: "https://yourserver.com/after.jpg"),
            config: SliderConfig(
                animated: false,
                start: 0.2,
                end: 0.8,
                imageCornerRadius: 12,
                isHelpingLabelHidden: false,
                contentType: .fit
            )
        )
        .frame(height: 400)
        .padding()
    }
}
