import Foundation

struct LadderEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var heightFeet: String
    var lastInspection: String
    var weightRating: String
    var createdAt: Date

    init(id: UUID = UUID(), name: String = "", heightFeet: String = "", lastInspection: String = "", weightRating: String = "", createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.heightFeet = heightFeet
        self.lastInspection = lastInspection
        self.weightRating = weightRating
        self.createdAt = createdAt
    }
}
