import Foundation

@MainActor
final class NewsCarouselViewModel: ObservableObject {
    @Published var items: [News] = []
    @Published var isLoading = false
    @Published var errorText: String?

    private let service = NewsService()

    func load() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            let news = try await service.fetchNews(limit: 10)
            items = news
            if news.isEmpty { errorText = "Новости не найдены" }
        } catch {
            items = []
            errorText = "Ошибка загрузки: \(error.localizedDescription)"
        }
    }
}
