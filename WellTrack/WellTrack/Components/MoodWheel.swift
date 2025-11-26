import SwiftUI

struct MoodWheel: View {
    let moods: [MoodViewModel.Mood] = MoodViewModel.Mood.allCases
    @Binding var selectedMood: MoodViewModel.Mood

    var body: some View {
        GeometryReader { proxy in
            let radius = min(proxy.size.width, proxy.size.height) / 2.5
            ZStack {
                ForEach(Array(moods.enumerated()), id: \.offset) { index, mood in
                    let angle = Angle(degrees: Double(index) / Double(moods.count) * 360)
                    let x = cos(angle.radians) * radius
                    let y = sin(angle.radians) * radius

                    Button {
                        selectedMood = mood
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Text(mood.emoji)
                            .font(.system(size: 28))
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(selectedMood == mood ? AppColors.accent.opacity(0.25) : Color.clear)
                            )
                    }
                    .position(x: proxy.size.width / 2 + x,
                              y: proxy.size.height / 2 + y)
                }
            }
        }
    }
}

#Preview {
    StatefulMoodWheelPreview()
}

private struct StatefulMoodWheelPreview: View {
    @State private var selected: MoodViewModel.Mood = .neutral

    var body: some View {
        VStack(spacing: AppTheme.Spacing.l) {
            MoodWheel(selectedMood: $selected)
                .frame(width: 240, height: 240)
            Text("Selected: \(selected.label)")
                .appBodyStyle()
        }
        .padding(AppTheme.Spacing.l)
        .appScreenBackground()
    }
}
