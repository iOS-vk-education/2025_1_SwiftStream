import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseCore

class NavigationViewModel: ObservableObject {
    @Published var classrooms: [Classroom] = []
    @Published var floors: [Floor] = []
    @Published var isLoading = false
    @Published var route: [ClassroomWithFloor] = []
    @Published var errorMessage: String? = nil
    @Published var routeSegments: [String: [ClassroomWithFloor]] = [:]
    @Published var currentFloorSegment: [ClassroomWithFloor] = []
    @Published var nextFloorInfo: (floor: String, count: Int)? = nil

    private var classroomsWithFloorCache: [String: [ClassroomWithFloor]] = [:]
 
    private let db: Firestore

    init() {
        guard let navApp = FirebaseApp.app(name: "navigation") else {
            fatalError("Firebase-аппликация 'navigation' не найдена")
        }
        self.db = Firestore.firestore(app: navApp)

        loadFloors()
    }
    
    

    func loadFloors() {
        isLoading = true

        db.collection("floors").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = "Ошибка загрузки этажей: \(error.localizedDescription)"
                    self.isLoading = false
                    return
                }

                self.floors = snapshot?.documents.compactMap { document in
                    try? document.data(as: Floor.self)
                } ?? []

                print("Загружено этажей: \(self.floors.count)")
                self.loadClassroomsForFloor("8")
            }
        }
    }

    func loadClassroomsForFloor(_ floorNumber: String) {
        print("Загружаю кабинеты для этажа \(floorNumber)...")

        let floorDocId = "floor\(floorNumber)"

        db.collection("floors").document(floorDocId).collection("classrooms").getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Ошибка загрузки кабинетов: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.classrooms = []
                    return
                }

                var classrooms: [Classroom] = []
                var classroomsWithFloor: [ClassroomWithFloor] = []

                for document in documents {
                    if let classroom = try? document.data(as: Classroom.self) {
                        classrooms.append(classroom)
                        classroomsWithFloor.append(ClassroomWithFloor(
                            classroom: classroom,
                            floor: floorNumber
                        ))
                    }
                }

                print("Загружено кабинетов для этажа \(floorNumber): \(classrooms.count)")

                self.classrooms = classrooms
                self.classroomsWithFloorCache[floorNumber] = classroomsWithFloor
            }
        }
    }

    func findRoute(from startNumber: String, to endNumber: String, completion: ((Bool) -> Void)? = nil) {
        print("\n Поиск маршрута между этажами: \(startNumber) → \(endNumber)")

        guard let startFloor = extractFloor(from: startNumber),
              let endFloor = extractFloor(from: endNumber) else {
            errorMessage = "Неверный номер кабинета"
            completion?(false)
            return
        }

        print("Этажи определены: старт на \(startFloor), конец на \(endFloor)")

        if startFloor == endFloor {
            print("Маршрут в пределах этажа \(startFloor)")
            findRouteOnSingleFloor(startNumber: startNumber, endNumber: endNumber, floor: startFloor, completion: completion)
            return
        }

        print("Многоэтажный маршрут: этаж \(startFloor) → этаж \(endFloor)")

        let isStartFloorLoaded = classroomsWithFloorCache[startFloor] != nil
        let isEndFloorLoaded = classroomsWithFloorCache[endFloor] != nil

        if !isStartFloorLoaded {
            loadClassroomsForFloor(startFloor)
        }

        if !isEndFloorLoaded {
            loadClassroomsForFloor(endFloor)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.findMultiFloorRoute(
                startNumber: startNumber,
                endNumber: endNumber,
                startFloor: startFloor,
                endFloor: endFloor,
                completion: completion
            )
        }
    }

    private func findMultiFloorRoute(startNumber: String, endNumber: String,
                                     startFloor: String, endFloor: String,
                                     completion: ((Bool) -> Void)? = nil) {

        print("\n Начинаю поиск многоэтажного маршрута...")

        guard let startNodes = classroomsWithFloorCache[startFloor],
              let endNodes = classroomsWithFloorCache[endFloor],
              let startNode = startNodes.first(where: { $0.classroom.number == startNumber }),
              let endNode = endNodes.first(where: { $0.classroom.number == endNumber }),
              let startElevator = startNodes.first(where: { $0.classroom.number == "elevator" }),
              let endElevator = endNodes.first(where: { $0.classroom.number == "elevator" }) else {
            errorMessage = "Данные для построения маршрута не найдены"
            completion?(false)
            return
        }

        if let routeToElevator = findRouteBetween(from: startNode, to: startElevator, nodes: startNodes),
           let routeFromElevator = findRouteBetween(from: endElevator, to: endNode, nodes: endNodes) {

            var fullRoute: [ClassroomWithFloor] = []
            fullRoute.append(contentsOf: routeToElevator)
            fullRoute.append(endElevator)

            if routeFromElevator.count > 1 {
                fullRoute.append(contentsOf: Array(routeFromElevator.dropFirst()))
            }

            if let first = fullRoute.first, first.classroom.number != startNumber {
                fullRoute.reverse()
            }

            print("\n Финальный маршрут построен!")
            print("   Путь: \(fullRoute.map { "\($0.classroom.number)(\($0.floor))" }.joined(separator: " → "))")

            self.route = fullRoute
            self.updateRouteSegments()
            self.errorMessage = nil
            completion?(true)

        } else {
            errorMessage = "Не могу найти путь через лифты"
            completion?(false)
        }
    }

    private func findRouteOnSingleFloor(startNumber: String, endNumber: String,
                                        floor: String, completion: ((Bool) -> Void)? = nil) {

        guard let nodes = classroomsWithFloorCache[floor],
              let startNode = nodes.first(where: { $0.classroom.number == startNumber }),
              let endNode = nodes.first(where: { $0.classroom.number == endNumber }) else {
            errorMessage = "Кабинет не найден на этаже \(floor)"
            completion?(false)
            return
        }

        if let route = findRouteBetween(from: startNode, to: endNode, nodes: nodes) {
            self.route = route
            updateRouteSegments()
            errorMessage = nil
            completion?(true)
        } else {
            errorMessage = "Маршрут не найден на этаже \(floor)"
            completion?(false)
        }
    }

    private func findRouteBetween(from start: ClassroomWithFloor, to end: ClassroomWithFloor,
                                  nodes: [ClassroomWithFloor]) -> [ClassroomWithFloor]? {

        var distances: [String: Double] = [:]
        var previous: [String: String] = [:]
        var unvisited = Set<String>()

        for node in nodes {
            distances[node.classroom.number] = Double.infinity
            unvisited.insert(node.classroom.number)
        }
        distances[start.classroom.number] = 0

        while !unvisited.isEmpty {
            guard let currentNode = unvisited.min(by: { distances[$0]! < distances[$1]! }) else {
                break
            }

            unvisited.remove(currentNode)

            if currentNode == end.classroom.number {
                break
            }

            guard let currentClassroom = nodes.first(where: { $0.classroom.number == currentNode }) else {
                continue
            }

            for neighborNumber in currentClassroom.classroom.neighbors {
                if unvisited.contains(neighborNumber) {
                    let alt = distances[currentNode]! + 1.0
                    if alt < distances[neighborNumber]! {
                        distances[neighborNumber] = alt
                        previous[neighborNumber] = currentNode
                    }
                }
            }
        }

        var path: [String] = []
        var current = end.classroom.number

        while let prev = previous[current] {
            path.insert(current, at: 0)
            current = prev
        }

        if path.isEmpty && start.classroom.number != end.classroom.number {
            return nil
        }

        path.insert(start.classroom.number, at: 0)

        return path.compactMap { number in
            nodes.first(where: { $0.classroom.number == number })
        }
    }

    private func updateRouteSegments() {
        routeSegments.removeAll()
        currentFloorSegment.removeAll()
        nextFloorInfo = nil

        guard !route.isEmpty else { return }

        for classroomWithFloor in route {
            if routeSegments[classroomWithFloor.floor] == nil {
                routeSegments[classroomWithFloor.floor] = []
            }
            routeSegments[classroomWithFloor.floor]?.append(classroomWithFloor)
        }
    }

    func updateDisplayForFloor(_ floor: String) {
        currentFloorSegment.removeAll()
        nextFloorInfo = nil

        guard !route.isEmpty else { return }

        if let segment = routeSegments[floor] {
            currentFloorSegment = segment
        }

        let floorsInRoute = getFloorsInRouteOrder()
        if let currentIndex = floorsInRoute.firstIndex(of: floor),
           currentIndex + 1 < floorsInRoute.count {
            let nextFloor = floorsInRoute[currentIndex + 1]
            nextFloorInfo = (nextFloor, routeSegments[nextFloor]?.count ?? 0)
        }
    }

    private func getFloorsInRouteOrder() -> [String] {
        var floors: [String] = []
        var lastFloor: String? = nil

        for classroomWithFloor in route {
            if classroomWithFloor.floor != lastFloor {
                floors.append(classroomWithFloor.floor)
                lastFloor = classroomWithFloor.floor
            }
        }

        return floors
    }

    func clearRoute() {
        route.removeAll()
        routeSegments.removeAll()
        currentFloorSegment.removeAll()
        nextFloorInfo = nil
        errorMessage = nil
    }

    private func extractFloor(from number: String) -> String? {
        if number == "elevator" {
            for (floor, classrooms) in classroomsWithFloorCache {
                if classrooms.contains(where: { $0.classroom.number == "elevator" }) {
                    return floor
                }
            }
            return nil
        }

        guard let firstChar = number.first, firstChar.isNumber else {
            return nil
        }
        return String(firstChar)
    }
}
