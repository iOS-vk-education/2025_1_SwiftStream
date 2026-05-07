import Foundation

@MainActor
final class NewsCarouselViewModel: ObservableObject {
    @Published var items: [News] = []
    @Published var isLoading = false
    @Published var errorText: String?

    private let service = NewsService()
    private var hasLoadedSuccessfully = false
    private var didTryInitialLoad = false

    func loadIfNeeded() async {
        guard !didTryInitialLoad else { return }

        didTryInitialLoad = true
        await load(force: true)
    }

    func load(force: Bool = false) async {
        if isLoading {
            return
        }

        if hasLoadedSuccessfully && !force {
            return
        }

        isLoading = true
        errorText = nil

        do {
            let news = try await service.fetchNews(limit: 10)

            items = news
            hasLoadedSuccessfully = true

            if news.isEmpty {
                errorText = "Новости не найдены"
            }
        } catch {
            items = []
            hasLoadedSuccessfully = false
            errorText = "Новости не получилось загрузить"
        }

        isLoading = false
    }
}
