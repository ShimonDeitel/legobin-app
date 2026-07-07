import SwiftUI

/// Unique visual identity for Lego Bin: primary brick red with sunny yellow.
enum Theme {
    static let accent = Color(hex: "#D6262A")
    static let accentSecondary = Color(hex: "#F2B705")
    static let background = Color(hex: "#F5F0E6")
    static let ink = Color(hex: "#211A14")

    static var titleFont: Font {
        Font.system(.largeTitle, design: .rounded).weight(.bold)
    }

    static var bodyFont: Font {
        Font.system(.body, design: .rounded)
    }

    static var cardCornerRadius: CGFloat { 18 }
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
