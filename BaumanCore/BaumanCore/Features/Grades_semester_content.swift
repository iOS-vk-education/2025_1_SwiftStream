import SwiftUI

// контент внутри семестров

struct SemesterSection: View {
    let title: String
    let isExpanded: Bool
    let onToggle: () -> Void
    let subjects: [(String, String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {


                HStack {
                    Text(title)
                        .font(.title2)
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle()) // делает весь HStack "кликабельным"
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        onToggle()
                    }
            }


            ZStack {
                if isExpanded {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(subjects, id: \.0) { subject in
                            HStack(alignment: .center) {
                                Text(subject.0)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)

                                Spacer(minLength: 12)

                                Text(subject.1)
                                    .foregroundColor(subject.2)
                                    .multilineTextAlignment(.trailing)
                                    .lineLimit(1)
                            }
                        }
                    }
                   
                    .padding(.top, 4)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .clipped()
        }
    }
}
