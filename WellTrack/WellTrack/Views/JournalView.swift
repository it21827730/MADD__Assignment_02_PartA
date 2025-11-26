import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var isPresentingEditor = false

    var body: some View {
        Group {
            if viewModel.entries.isEmpty {
                VStack(spacing: 16) {
                    Image("journal_empty")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 220)
                        .opacity(0.95)

                    Text("Start your first journal entry")
                        .appHeadingStyle()
                    Text("Tap the + button to add your thoughts for today.")
                        .appCaptionStyle()
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.entries) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.title)
                                .font(.headline)
                            Text(entry.date, style: .date)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Journal")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isPresentingEditor = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.accent)
                }
            }
        }
        .sheet(isPresented: $isPresentingEditor) {
            JournalEditorView(viewModel: viewModel)
        }
    }
}

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalViewModel
    @State private var title: String = ""
    @State private var bodyText: String = ""
    private let selectedDateKey = "selected_date_timestamp"
    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Title", text: $title)
                    .textFieldStyle(.roundedBorder)

                TextEditor(text: $bodyText)
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                Spacer()

                Button {
                    viewModel.addEntry(title: title, body: bodyText, date: selectedDate)
                    dismiss()
                } label: {
                    Text("Save")
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppColors.accent)
                }
                // Save action is now the filled purple button at the bottom.
            }
            .onAppear {
                let ts = UserDefaults.standard.double(forKey: selectedDateKey)
                if ts > 0 {
                    selectedDate = Date(timeIntervalSince1970: ts)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        JournalView(viewModel: JournalViewModel())
    }
}
