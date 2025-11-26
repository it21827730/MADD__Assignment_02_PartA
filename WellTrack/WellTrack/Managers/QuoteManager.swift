import Foundation

/// QuoteManager fetches a simple motivational quote from a public JSON API.
final class QuoteManager {
    static let shared = QuoteManager()

    private init() {}

    struct QuoteResponse: Decodable {
        let q: String?
        let a: String?
    }

    /// Fetches a random motivational quote.
    /// Uses zenquotes.io public API; on failure, returns a fallback string.
    func fetchQuote() async -> String {
        guard let url = URL(string: "https://zenquotes.io/api/random") else {
            return "Stay hydrated and keep moving forward."
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode([QuoteResponse].self, from: data),
               let first = decoded.first,
               let text = first.q {
                if let author = first.a, !author.isEmpty {
                    return "\"\(text)\" — \(author)"
                } else {
                    return text
                }
            } else {
                return "Good habits today create a healthier you tomorrow."
            }
        } catch {
            return "Remember to drink water and take care of yourself today."
        }
    }
}
