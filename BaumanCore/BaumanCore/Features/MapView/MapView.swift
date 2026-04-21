import SwiftUI
import FirebaseFirestore

struct MapView: View {
    @StateObject private var viewModel = NavigationViewModel()
    @EnvironmentObject var appState: AppState
    @State private var fromLocation = ""
    @State private var toLocation = ""
    @State private var selectedFloor = "1"
    @State private var showingLowerFloors = true
    @State private var isRouteBuilt = false
    @State private var singlePointClassroom: ClassroomWithFloor?
    @State private var singlePointType: PointType = .start
    @Environment(\.colorScheme) var colorScheme

    enum PointType {
        case start
        case end
    }

    let lowerFloors = ["1", "2", "3", "4", "5", "6"]
    let upperFloors = ["7", "8", "9", "10", "11", "12"]

    var currentFloors: [String] {
        showingLowerFloors ? lowerFloors : upperFloors
    }

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView(showsIndicators: false) {
                    mapContent(geometry: geometry)
                }
                .navigationBarHidden(true)
                .onChange(of: selectedFloor) { newFloor in
                    viewModel.updateDisplayForFloor(newFloor)
                }
                .onChange(of: fromLocation) { _ in
                    viewModel.clearRoute()
                    singlePointClassroom = nil
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isRouteBuilt = false
                    }
                }
                .onChange(of: toLocation) { _ in
                    viewModel.clearRoute()
                    singlePointClassroom = nil
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isRouteBuilt = false
                    }
                }
            }
            .onAppear {
                handlePendingLocations()
            }
        }
    }
    
    @ViewBuilder
    private func mapContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Text(Translation.Map.title)
                .font(.system(size: min(34, geometry.size.width * 0.09), weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, max(16, geometry.size.width * 0.05))
                .padding(.top, isRouteBuilt ? 0 : max(40, geometry.safeAreaInsets.top + 10))
                .padding(.bottom, max(20, geometry.size.height * 0.03))

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
                                .font(.system(size: max(14, min(16, geometry.size.width * 0.04)), weight: .medium))
                                .foregroundColor(selectedFloor == floor ? Colors.white : Colors.black)
                                .frame(height: max(32, geometry.size.height * 0.045))
                                .frame(maxWidth: .infinity)
                                .background(selectedFloor == floor ? Colors.MainColor : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }

                        if floor != currentFloors.last {
                            Text("|")
                                .foregroundColor(.gray)
                                .font(.system(size: max(12, min(14, geometry.size.width * 0.035)), weight: .medium))
                        }
                    }

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showingLowerFloors.toggle()
                            selectedFloor = showingLowerFloors ? "1" : "7"
                            resetZoomAndScroll()
                            viewModel.loadClassroomsForFloor(selectedFloor)
                            viewModel.updateDisplayForFloor(selectedFloor)
                        }
                    }) {
                        Image(systemName: showingLowerFloors ? "chevron.down" : "chevron.up")
                            .font(.system(size: max(12, min(14, geometry.size.width * 0.035)), weight: .medium))
                            .foregroundColor(Colors.MainColor)
                            .frame(width: max(28, geometry.size.width * 0.08), height: max(28, geometry.size.height * 0.04))
                            .background(Colors.MainColor.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, max(12, geometry.size.width * 0.03))
            .padding(.vertical, max(10, geometry.size.height * 0.015))
            .background(Colors.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
            )
            .padding(.horizontal, max(16, geometry.size.width * 0.05))
            .padding(.bottom, max(20, geometry.size.height * 0.03))

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color(white: 0.12) : .white)
                    .shadow(color: colorScheme == .dark ? .black.opacity(0.3) : .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3), lineWidth: 1)
                    )

                ZStack {
                    Image(selectedFloor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)

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
                    } else if let singlePoint = singlePointClassroom, singlePoint.floor == selectedFloor {
                        Circle()
                            .fill(singlePointType == .start ? .red : .black)
                            .frame(width: 20, height: 20)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .position(
                                x: CGFloat(singlePoint.classroom.coordinateX),
                                y: CGFloat(singlePoint.classroom.coordinateY)
                            )
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
            .padding(.bottom, max(16, geometry.size.height * 0.02))

            if let nextFloorInfo = viewModel.nextFloorInfo {
                HStack {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(Colors.MainColor)
                        .font(.system(size: max(12, min(14, geometry.size.width * 0.035))))

                    Text(routeContinuesText(for: nextFloorInfo.floor))
                        .font(.system(size: max(12, min(14, geometry.size.width * 0.035)), weight: .medium))
                        .foregroundColor(Colors.MainColor)

                    Spacer()

                    Button(Translation.Map.goButton) {
                        withAnimation {
                            selectedFloor = nextFloorInfo.floor
                            resetZoomAndScroll()
                            viewModel.loadClassroomsForFloor(nextFloorInfo.floor)
                            viewModel.updateDisplayForFloor(nextFloorInfo.floor)
                        }
                    }
                    .font(.system(size: max(12, min(14, geometry.size.width * 0.035)), weight: .medium))
                    .foregroundColor(Colors.white)
                    .padding(.horizontal, max(10, geometry.size.width * 0.03))
                    .padding(.vertical, max(4, geometry.size.height * 0.005))
                    .background(Colors.MainColor)
                    .cornerRadius(8)
                }
                .padding(.horizontal, max(12, geometry.size.width * 0.04))
                .padding(.vertical, max(8, geometry.size.height * 0.01))
                .background(Colors.MainColor.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, max(16, geometry.size.width * 0.05))
                .padding(.bottom, max(8, geometry.size.height * 0.01))
            }

            HStack(spacing: max(12, geometry.size.width * 0.04)) {
                ZStack {
                    TextField("", text: $fromLocation)
                        .padding(.horizontal, max(12, geometry.size.width * 0.03))
                        .frame(height: max(44, geometry.size.height * 0.06))
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    if fromLocation.isEmpty {
                        Text(Translation.Map.fromPlaceholder)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, max(12, geometry.size.width * 0.03))
                    }
                }

                ZStack {
                    TextField("", text: $toLocation)
                        .padding(.horizontal, max(12, geometry.size.width * 0.03))
                        .frame(height: max(44, geometry.size.height * 0.06))
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    if toLocation.isEmpty {
                        Text(Translation.Map.toPlaceholder)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, max(12, geometry.size.width * 0.03))
                    }
                }
            }
            .frame(height: max(44, geometry.size.height * 0.06))
            .padding(.horizontal, max(16, geometry.size.width * 0.05))
            .padding(.bottom, max(16, geometry.size.height * 0.02))

            Button(action: {
                findRoute()
            }) {
                Text(Translation.Map.buildRouteButton)
                    .font(.system(size: max(15, min(17, geometry.size.width * 0.045)), weight: .semibold))
                    .foregroundColor(Colors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: max(44, geometry.size.height * 0.06))
                    .background(Colors.MainColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal, max(16, geometry.size.width * 0.05))
            .padding(.bottom, max(16, geometry.size.height * 0.02))
            .disabled(fromLocation.isEmpty || toLocation.isEmpty)
            .opacity(fromLocation.isEmpty || toLocation.isEmpty ? 0.6 : 1.0)

            if viewModel.isLoading {
                Text(Translation.Map.loadingData)
                    .font(.caption)
                    .foregroundColor(Colors.MainColor)
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
                .frame(height: geometry.safeAreaInsets.bottom + 60)
        }
    }
    
    private func handlePendingLocations() {
        let pendingFrom = appState.pendingFromLocation
        let pendingTo = appState.pendingToLocation
        
        if let from = pendingFrom {
            fromLocation = from
            appState.pendingFromLocation = nil
        }
        if let to = pendingTo {
            toLocation = to
            appState.pendingToLocation = nil
        }
        
        if pendingFrom != nil && pendingTo == nil {
            showSinglePoint(location: pendingFrom!, type: .start)
        } else if pendingTo != nil && pendingFrom == nil {
            showSinglePoint(location: pendingTo!, type: .end)
        } else if pendingFrom != nil && pendingTo != nil {
            findRoute()
        }
    }
    
    private func showSinglePoint(location: String, type: PointType) {
        guard let floor = extractFloor(from: location) else { return }
        
        if let floorInt = Int(floor), floorInt >= 7 {
            showingLowerFloors = false
        } else {
            showingLowerFloors = true
        }
        
        selectedFloor = floor
        singlePointType = type
        
        viewModel.loadClassroomsForFloor(floor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let node = viewModel.getClassroomWithFloor(number: location, floor: floor) {
                singlePointClassroom = node
                viewModel.updateDisplayForFloor(floor)
            }
        }
    }
    
    private func routeContinuesText(for floor: String) -> String {
        let format = NSLocalizedString("map_route_continues_format", comment: "")
        return String(format: format, floor)
    }

    private func findRoute() {
        guard !fromLocation.isEmpty, !toLocation.isEmpty else { return }

        viewModel.clearRoute()
        singlePointClassroom = nil

        viewModel.findRoute(from: fromLocation, to: toLocation) { success in
            if success {
                if let firstClassroomWithFloor = viewModel.route.first {
                    selectedFloor = firstClassroomWithFloor.floor
                    
                    if let floorInt = Int(firstClassroomWithFloor.floor), floorInt >= 7 {
                        showingLowerFloors = false
                    } else {
                        showingLowerFloors = true
                    }
                    
                    viewModel.updateDisplayForFloor(firstClassroomWithFloor.floor)
                }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    isRouteBuilt = true
                }
            }
        }
    }

    private func getPointColor(isFirstInRoute: Bool, isLastInRoute: Bool, isElevator: Bool) -> Color {
        if isFirstInRoute {
            return .red
        } else if isLastInRoute {
            return .black
        } else if isElevator {
            return Colors.MainColor
        } else {
            return .clear
        }
    }

    private func extractFloor(from number: String) -> String? {
        let digits = number.filter { $0.isNumber }
        
        switch digits.count {
        case 3:
            return String(digits.prefix(1))
        case 4:
            return String(digits.prefix(2))
        default:
            return digits.isEmpty ? nil : String(digits.prefix(1))
        }
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
