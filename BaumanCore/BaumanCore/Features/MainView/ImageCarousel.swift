import SwiftUI

struct ImageCarousel: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var vm = NewsCarouselViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if vm.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(Colors.MainColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if vm.items.isEmpty && vm.errorText != nil {
                    VStack(spacing: 10) {
                        Button {
                            Task {
                                await vm.load(force: true)
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 52, height: 52)
                                .background(Colors.MainColor)
                                .clipShape(Circle())
                        }

                        Text(Translation.MainPage.newsLoadFailed)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if !vm.items.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(vm.items) { item in
                                Button {
                                    if let url = item.pageURL {
                                        openURL(url)
                                    }
                                } label: {
                                    NewsCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .frame(height: 200)
        }
        .frame(height: 220)
        .task {
            await vm.loadIfNeeded()
        }
    }
}

private struct NewsCard: View {
    let item: News
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                default:
                    Color(.systemGray6)
                        .shimmering()
                }
            }
            .frame(width: 360, height: 200)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(item.title)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(2)
                .padding(12)
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(12)
        }
        .frame(width: 360, height: 200)
    }
}

extension View {
    func shimmering() -> some View {
        self.overlay(
            LinearGradient(
                colors: [.clear, .white.opacity(0.3), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 100)
            .rotationEffect(.degrees(45))
            .animation(
                .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: false),
                value: UUID()
            )
        )
    }
}
