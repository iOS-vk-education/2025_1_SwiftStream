//import Foundation
//
//@MainActor
//final class NewsCarouselViewModel: ObservableObject {
//    @Published var items: [News] = []
//    @Published var isLoading = false
//    @Published var errorText: String?
//
//    private let service = NewsService()
//
//    func load() async {
//        isLoading = true
//        errorText = nil
//        defer { isLoading = false }
//
//        do {
//            let news = try await service.fetchNews(limit: 10)
//            items = news
//            if news.isEmpty { errorText = "Новости не найдены" }
//        } catch {
//            items = []
//            errorText = "Ошибка загрузки: \(error.localizedDescription)"
//        }
//    }
//}
import Foundation

@MainActor
final class NewsCarouselViewModel: ObservableObject {
    @Published var items: [News] = []
    @Published var isLoading = false
    @Published var errorText: String?

    private let service = NewsService()
    private var hasLoaded = false

    func load() async {
        guard !hasLoaded else { return }
        
        isLoading = true
        errorText = nil
        
        defer {
            isLoading = false
            hasLoaded = true
        }
        
        do {
            let news = try await service.fetchNews(limit: 10)
            items = news
            if news.isEmpty { errorText = "Новости не найдены" }
        } catch {
            if items.isEmpty {
                items = []
                errorText = "Ошибка загрузки: \(error.localizedDescription)"
            }
        }
    }
}
