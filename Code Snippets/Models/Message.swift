import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var sender: String
    var content: String
    var timestamp: Date
}
