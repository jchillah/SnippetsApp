struct FriendInvitation: Identifiable, Codable {
    var id: String
    var senderID: String
    var receiverID: String
    var status: InvitationStatus
}

enum InvitationStatus: String, Codable {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}
