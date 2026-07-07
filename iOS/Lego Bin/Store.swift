import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [SetItem] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Always kept comfortably above seed data count so a
    /// fresh install never trips the paywall immediately.
    static let freeLimit = 15

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("legobin_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: SetItem) {
        guard canAddMore else { return }
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: SetItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: SetItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([SetItem].self, from: data) {
            items = decoded
        } else {
            items = seedData()
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func seedData() -> [SetItem] {
        [
        SetItem(name: "Millennium Falcon", setNumber: "75192", pieceCount: "7541", buildStatus: "Built"),
        SetItem(name: "Eiffel Tower", setNumber: "10307", pieceCount: "10001", buildStatus: "Boxed"),
        SetItem(name: "Nasa Apollo Saturn V", setNumber: "92176", pieceCount: "1969", buildStatus: "Built")
        ]
    }
}
