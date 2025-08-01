
# 📷 ImageSliderCompareView

A lightweight SwiftUI package that lets users **compare two images interactively** with a slider. Perfect for showcasing before/after effects, AI-enhanced images, or visual changes over time. Supports **pinch-to-zoom**, **drag**, and **animated transitions**.

<img width="327" height="698" alt="Screenshot 2025-08-01 at 3 28 20 PM" src="https://github.com/user-attachments/assets/d14f4078-f137-40e9-bc6c-e6b78495188b" />

Supports:

✅ Remote URLs  
✅ Local `UIImage`s  
✅ Pinch-to-zoom  
✅ Drag-to-pan  
✅ Auto-play animation


## 🧰 Features

- 🖼️ Compare images side-by-side using a slider
- 📱 Smooth zoom and pan gestures
- 🔁 Optional slider animation
- 🎯 Fully customizable through `SliderConfig`
- 🧵 Lightweight and easy to integrate

---

## 📦 Installation

### Using Swift Package Manager

1. In Xcode, go to **File > Add Packages** > Enter "https://github.com/wajahatx/ImageSliderCompareView"
2. Paste this URL in the search bar:
3. Choose the latest version and add it to your target.

---

## 🚀 Usage

### ✅ Basic Usage with Remote URLs

```swift
import ImageSliderCompareView

struct ContentView: View {
    var body: some View {
        ImageSliderCompareView(
            before: URL(string: "https://example.com/before.jpg"),
            after: URL(string: "https://example.com/after.jpg")
        )
        .frame(height: 400)
    }
}
```

---

### ✅ Basic Usage with Local UIImages

```swift
import ImageSliderCompareView

struct ContentView: View {
    var body: some View {
        let beforeImage = UIImage(named: "before")
        let afterImage = UIImage(named: "after")

        ImageSliderCompareView(
            beforeImage: beforeImage,
            afterImage: afterImage
        )
        .frame(height: 400)
    }
}
```

---

### ✅ Mixed Usage: Local & Remote

```swift
// Local before image, remote after image
ImageSliderCompareView(
    beforeImage: UIImage(named: "before"),
    after: URL(string: "https://example.com/after.jpg")
)

// Remote before image, local after image
ImageSliderCompareView(
    before: URL(string: "https://example.com/before.jpg"),
    afterImage: UIImage(named: "after")
)
```

---

### ⚙️ Advanced Usage with `SliderConfig`

```swift
let config = SliderConfig(
    animated: true,                 // Animate slider back and forth
    start: 0.25,                    // Animation start position (0.0 to 1.0)
    end: 0.75,                      // Animation end position
    imageCornerRadius: 12,         // Corner radius for both images
    isHelpingLabelHidden: true,    // Hide "Before"/"After" labels
    contentType: .fill             // Image content mode: .fit or .fill
)

ImageSliderCompareView(
    beforeSource: .image(UIImage(named: "before")),
    afterSource: .url(URL(string: "https://example.com/after.jpg")),
    config: config
)
.frame(height: 400)
```

## 📄 License

MIT License

---

## 👋 Contributing

PRs are welcome! Please open an issue first to discuss any significant changes.

---
