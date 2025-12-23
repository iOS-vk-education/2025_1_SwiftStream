import Foundation

struct NewsService {

    func fetchNews(limit: Int = 10) async throws -> [News] {
        let url = URL(string: "https://bmstu.ru/news")!
        let (data, _) = try await URLSession.shared.data(from: url)

        guard
            let html = String(data: data, encoding: .utf8),
            let jsonString = extractNextDataJSON(from: html),
            let jsonData = jsonString.data(using: .utf8)
        else { return [] }

        let obj = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        let props = obj?["props"] as? [String: Any]
        let pageProps = props?["pageProps"] as? [String: Any]
        let initialState = props?["initialState"] as? [String: Any]

        let items = ((initialState?["news"] as? [String: Any])?["data"] as? [String: Any])?["items"] as? [[String: Any]]
            ?? (pageProps?["items"] as? [[String: Any]])
            ?? []

        let parsed: [News] = items.prefix(limit).compactMap { item in
            let id = String(describing: item["slug"] ?? item["id"] ?? UUID().uuidString)
            let title = (item["title"] as? String) ?? ""
            let img = item["imagePreview"] as? String ?? item["image"] as? String
            let page = item["page_url"] as? String ?? item["pageUrl"] as? String ?? item["url"] as? String

            let pageURL = makePageURL(page)
            let imageURL = makeImageURL(img)

            return News(id: id, title: title, imageURL: imageURL, pageURL: pageURL)
        }

        return parsed
    }


    private func extractNextDataJSON(from html: String) -> String? {
        guard let rangeStart = html.range(of: #"id="__NEXT_DATA__" type="application/json">"#, options: .regularExpression) else {
            return nil
        }
        let afterStart = html[rangeStart.upperBound...]
        guard let end = afterStart.range(of: #"</script>"#, options: .regularExpression) else {
            return nil
        }
        return String(afterStart[..<end.lowerBound])
    }

    private func makePageURL(_ s: String?) -> URL? {
        guard let s, !s.isEmpty else { return nil }
        if s.hasPrefix("http") { return URL(string: s) }
        if s.hasPrefix("/") { return URL(string: "https://bmstu.ru" + s) }
        return URL(string: "https://bmstu.ru/" + s)
    }

    private func makeImageURL(_ s: String?) -> URL? {
        guard let s, !s.isEmpty else { return nil }
        if s.hasPrefix("http") { return URL(string: s) }
        if s.hasPrefix("//") { return URL(string: "https:" + s) }
        if s.hasPrefix("/") {
            return URL(string: "https://api.www.bmstu.ru" + s) ?? URL(string: "https://bmstu.ru" + s)
        }
        return URL(string: "https://api.www.bmstu.ru/" + s) ?? URL(string: s)
    }
}
