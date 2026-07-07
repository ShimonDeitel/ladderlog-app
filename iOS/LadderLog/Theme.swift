import SwiftUI

/// forest-green work gear tones with a caution-yellow accent
enum Theme {
    static let primary = Color(red: 0.200, green: 0.290, blue: 0.239)
    static let accent = Color(red: 0.949, green: 0.757, blue: 0.306)
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}
