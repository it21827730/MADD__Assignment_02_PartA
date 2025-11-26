import SwiftUI

struct MoodTrackerView: View {
    @ObservedObject var viewModel: MoodViewModel
    @State private var note: String = ""
    private let selectedDateKey = "selected_date_timestamp"
    @State private var selectedDate: Date = Date()

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Text("How are you feeling today?")
                .appHeadingStyle()

            moodPicker

            VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
                Text("Notes")
                    .appHeadingStyle()
                TextEditor(text: $note)
                    .frame(minHeight: 120)
                    .padding(AppTheme.Spacing.s)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                            .fill(AppColors.primaryBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                            .stroke(AppColors.borderSubtle, lineWidth: 1)
                    )
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

            Spacer()

            Button {
                viewModel.saveMood(note: note, date: selectedDate)
                note = ""
            } label: {
                Text("Save Mood")
                    .appPrimaryButtonStyle()
            }
        }
        .padding(AppTheme.Spacing.l)
        .navigationTitle("Mood Tracker")
        .appScreenBackground()
        .onAppear {
            let ts = UserDefaults.standard.double(forKey: selectedDateKey)
            if ts > 0 {
                selectedDate = Date(timeIntervalSince1970: ts)
            }
        }
    }

    private var moodPicker: some View {
        HStack(spacing: 16) {
            ForEach(MoodViewModel.Mood.allCases, id: \.self) { mood in
                Button {
                    viewModel.selectedMood = mood
                } label: {
                    Text(mood.emoji)
                        .font(.system(size: 36))
                        .padding(AppTheme.Spacing.m)
                        .background(
                            viewModel.selectedMood == mood
                            ? AppColors.accent.opacity(0.2)
                            : Color.clear
                        )
                        .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MoodTrackerView(viewModel: MoodViewModel())
    }
}
