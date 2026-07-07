import Foundation

struct SetItem: Identifiable, Codable, Equatable {
    var id: UUID
    var dateAdded: Date
    var name: String
    var setNumber: String
    var pieceCount: String
    var buildStatus: String

    init(id: UUID = UUID(), dateAdded: Date = Date(), name: String, setNumber: String, pieceCount: String, buildStatus: String) {
        self.id = id
        self.dateAdded = dateAdded
        self.name = name
        self.setNumber = setNumber
        self.pieceCount = pieceCount
        self.buildStatus = buildStatus
    }

    static func blank() -> SetItem {
        SetItem(name: "", setNumber: "", pieceCount: "", buildStatus: "")
    }
}
