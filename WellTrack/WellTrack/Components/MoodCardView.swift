import SwiftUI

struct MoodCardViewModel: Identifiable {
    let id = UUID()
    let date: Date
    let emoji: String
    let note: String
    let tags: [String]
}

struct MoodCardView: View {
    let viewModel: MoodCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.m) {
            HStack {
                Text(viewModel.emoji)
                    .font(.system(size: 32))
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.date, style: .date)
                        .appCaptionStyle()
                    Text(viewModel.date, style: .time)
                        .appCaptionStyle()
                }
                Spacer()
            }

            if !viewModel.note.isEmpty {
                Text(viewModel.note)
                    .appBodyStyle()
            }

            if !viewModel.tags.isEmpty {
                HStack(spacing: AppTheme.Spacing.s) {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        Text(tag)
                            .appCaptionStyle()
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(AppColors.primaryBackground)
                            )
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(AppColors.secondarySurface)
        )
        .shadow(color: AppColors.shadow,
                radius: AppTheme.Elevation.card.radius,
                x: AppTheme.Elevation.card.x,
                y: AppTheme.Elevation.card.y)
    }
}

#Preview {
    MoodCardView(
        viewModel: MoodCardViewModel(
            date: Date(),
            emoji: "🙂",
            note: "Feeling okay today, a bit tired but motivated.",
            tags: ["Study", "Exercise"]
        )
    )
    .padding(AppTheme.Spacing.l)
    .appScreenBackground()
}
