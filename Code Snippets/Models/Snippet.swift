import FirebaseFirestore
import Foundation

struct Snippet: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var code: String
}
