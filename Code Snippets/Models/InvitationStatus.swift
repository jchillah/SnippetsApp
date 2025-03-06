import Foundation

/// Repräsentiert den Status einer Freundschaftseinladung.
///
/// - pending: Die Einladung wurde gesendet, aber noch nicht beantwortet.
/// - accepted: Die Einladung wurde angenommen.
/// - rejected: Die Einladung wurde abgelehnt.
enum InvitationStatus: String {
    case pending
    case accepted
    case rejected
}

/// Repräsentiert eine Freundschaftseinladung zwischen zwei Nutzern.
struct FriendInvitation {
    /// Die eindeutige ID der Einladung.
    var id: String
    /// Die ID des sendenden Nutzers.
    var senderID: String
    /// Die ID des empfangenden Nutzers.
    var receiverID: String
    /// Der aktuelle Status der Einladung.
    var status: InvitationStatus
}
