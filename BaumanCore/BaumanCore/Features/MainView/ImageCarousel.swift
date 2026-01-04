import SwiftUI

struct ImageCarousel: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var vm = NewsCarouselViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            if vm.isLoading {
                ProgressView().padding(.horizontal, 16)
            }

            if let error = vm.errorText {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vm.items) { item in
                        Button {
                            if let url = item.pageURL { openURL(url) }
                        } label: {
                            NewsCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 220)
        }
        .task { await vm.load() }
    }
}

private struct NewsCard: View {
    let item: News

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color(.systemGray6)
                }
            }
            .frame(width: 360, height: 200)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(item.title)
                .foregroundColor(.white)
                .lineLimit(2)
                .padding(12)
                .background(Color.black.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(12)
        }
        .frame(width: 360, height: 200)
    }
}
