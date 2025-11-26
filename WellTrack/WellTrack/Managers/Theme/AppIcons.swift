import SwiftUI

/// Icon semantic roles mapped to Lavender Theme B colors.
enum AppIconColor {
    case primaryIcon
    case secondaryIcon
    case accentIcon
    case disabledIcon

    var color: Color {
        switch self {
        case .primaryIcon:
            return AppColors.textPrimary
        case .secondaryIcon:
            return AppColors.textSecondary
        case .accentIcon:
            return AppColors.accent
        case .disabledIcon:
            return AppColors.textSecondary.opacity(0.4)
        }
    }
}

extension Image {
    /// Loads an app icon from the asset catalog using a consistent naming scheme.
    static func appIcon(_ name: String) -> Image {
        Image(name)
    }
}

extension View {
    /// Tints SF Symbol or template image icons according to a semantic role.
    func appIconTint(_ role: AppIconColor) -> some View {
        self.foregroundStyle(role.color)
    }
}

#Preview("Icons") {
    HStack(spacing: AppTheme.Spacing.l) {
        Image(systemName: "drop.fill")
            .appIconTint(.accentIcon)
        Image(systemName: "face.smiling")
            .appIconTint(.primaryIcon)
        Image(systemName: "book.closed")
            .appIconTint(.secondaryIcon)
        Image(systemName: "bell")
            .appIconTint(.disabledIcon)
    }
    .font(.title)
    .padding(AppTheme.Spacing.l)
    .appScreenBackground()
}
