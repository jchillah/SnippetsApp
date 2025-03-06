import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var gender: String
    var birthDate: Date
    var profession: String
    @ServerTimestamp var registeredOn: Date?
}
