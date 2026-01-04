import SwiftUI
import FirebaseFirestore

struct MapView: View {
    @StateObject private var viewModel = NavigationViewModel()
    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var selectedFloor = "1"
    @State private var showingLowerFloors = true

    let lowerFloors = ["1", "2", "3", "4", "5", "6"]
    let upperFloors = ["7", "8", "9", "10", "11", "12"]

    var currentFloors: [String] {
        return showingLowerFloors ? lowerFloors : upperFloors
    }

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Навигатор")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 30)

                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        ForEach(currentFloors, id: \.self) { floor in
                            Button(action: {
                                selectedFloor = floor
                                resetZoomAndScroll()
                                viewModel.loadClassroomsForFloor(floor)
                                viewModel.updateDisplayForFloor(floor)
                            }) {
                                Text(floor)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedFloor == floor ? .white : .primary)
                                    .frame(height: 32)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedFloor == floor ? Color.blue : Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }

                            if floor != currentFloors.last {
                                Text("|")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14, weight: .medium))
                            }
                        }

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showingLowerFloors.toggle()
                                selectedFloor = showingLowerFloors ? "1" : "8"
                                resetZoomAndScroll()
                                viewModel.loadClassroomsForFloor(selectedFloor)
                                viewModel.updateDisplayForFloor(selectedFloor)
                            }
                        }) {
                            Image(systemName: showingLowerFloors ? "chevron.down" : "chevron.up")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.blue)
                                .frame(width: 32, height: 32)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    ZStack {
                        Image(selectedFloor)
                            .resizable()
                            .aspectRatio(contentMode: .fit)

                        if !viewModel.currentFloorSegment.isEmpty {
                            Path { path in
                                for (index, classroomWithFloor) in viewModel.currentFloorSegment.enumerated() {
                                    let point = CGPoint(
                                        x: CGFloat(classroomWithFloor.classroom.coordinateX),
                                        y: CGFloat(classroomWithFloor.classroom.coordinateY)
                                    )

                                    if index == 0 {
                                        path.move(to: point)
                                    } else {
                                        path.addLine(to: point)
                                    }
                                }
                            }
                            .stroke(Color.red, lineWidth: 3)

                            ForEach(viewModel.currentFloorSegment, id: \.classroom.number) { classroomWithFloor in


                                let isFirstInRoute = viewModel.route.first?.classroom.number == classroomWithFloor.classroom.number
                                let isLastInRoute = viewModel.route.last?.classroom.number == classroomWithFloor.classroom.number
                                let isElevator = classroomWithFloor.classroom.number == "elevator"

                                if isFirstInRoute || isLastInRoute || isElevator {
                                    Circle()
                                        .fill(getPointColor(
                                            isFirstInRoute: isFirstInRoute,
                                            isLastInRoute: isLastInRoute,
                                            isElevator: isElevator
                                        ))
                                        .frame(width: 20, height: 20)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .position(
                                            x: CGFloat(classroomWithFloor.classroom.coordinateX),
                                            y: CGFloat(classroomWithFloor.classroom.coordinateY)
                                        )
                                }
                            }
                        }
                    }
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                let newScale = scale * delta
                                if newScale >= 1.0 && newScale <= 5.0 {
                                    scale = newScale
                                }
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            }
                    )
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if scale > 1.0 {
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                    .simultaneousGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                withAnimation(.spring()) {
                                    if scale > 1.0 {
                                        resetZoomAndScroll()
                                    } else {
                                        scale = 2.0
                                        offset = .zero
                                        lastOffset = .zero
                                    }
                                }
                            }
                    )
                }
                .frame(width: 365, height: 388)
                .clipped()
                .padding(.bottom, 20)

                if let nextFloorInfo = viewModel.nextFloorInfo {
                    HStack {
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(.blue)
                            .font(.system(size: 14))

                        Text("Продолжение маршрута на \(nextFloorInfo.floor) этаже")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)

                        Spacer()

                        Button("Перейти") {
                            withAnimation {
                                selectedFloor = nextFloorInfo.floor
                                resetZoomAndScroll()
                                viewModel.loadClassroomsForFloor(nextFloorInfo.floor)
                                viewModel.updateDisplayForFloor(nextFloorInfo.floor)
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }

                HStack(spacing: 16) {
                    ZStack {
                        TextField("", text: $fromLocation)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )

                        if fromLocation.isEmpty {
                            Text("Откуда")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                        }
                    }

                    ZStack {
                        TextField("", text: $toLocation)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )

                        if toLocation.isEmpty {
                            Text("Куда")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                        }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                Button(action: {
                    findRoute()
                }) {
                    Text("Построить маршрут")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .disabled(fromLocation.isEmpty || toLocation.isEmpty)
                .opacity(fromLocation.isEmpty || toLocation.isEmpty ? 0.6 : 1.0)

                if viewModel.isLoading {
                    Text("Загрузка данных...")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }

                Spacer()
                    .frame(height: 80)
            }
            .padding(.bottom, 60)
            .navigationBarHidden(true)
            .onChange(of: selectedFloor) { newFloor in
                viewModel.updateDisplayForFloor(newFloor)
            }
            .onChange(of: fromLocation) { _ in
                viewModel.clearRoute()
            }
            .onChange(of: toLocation) { _ in
                viewModel.clearRoute()
            }
        }
    }

    private func findRoute() {
        guard !fromLocation.isEmpty, !toLocation.isEmpty else { return }

        viewModel.clearRoute()

        viewModel.findRoute(from: fromLocation, to: toLocation) { success in
            if success {
                print("Маршрут построен!")

                if let firstClassroomWithFloor = viewModel.route.first {
                    selectedFloor = firstClassroomWithFloor.floor
                    viewModel.updateDisplayForFloor(firstClassroomWithFloor.floor)
                }
            } else {
                print("Маршрут не найден")
            }
        }
    }

    private func getPointColor(isFirstInRoute: Bool, isLastInRoute: Bool, isElevator: Bool) -> Color {
        if isFirstInRoute {
            return Color.red
        } else if isLastInRoute {
            return Color.black
        } else if isElevator {
            return Color.blue
        } else {
            return Color.clear
        }
    }

    private func extractFloor(from number: String) -> String? {
        guard let firstChar = number.first, firstChar.isNumber else {
            return nil
        }
        return String(firstChar)
    }

    private func resetZoomAndScroll() {
        withAnimation(.spring()) {
            scale = 1.0
            offset = .zero
            lastOffset = .zero
            lastScale = 1.0
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedTab: 0)
    }
}
