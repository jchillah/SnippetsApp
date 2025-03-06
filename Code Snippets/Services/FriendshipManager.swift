import Foundation

class FriendshipManager: ObservableObject {
    @Published var invitations: [FriendInvitation] = []

    func sendFriendRequest(from senderID: String, to receiverID: String) {
        let newInvitation = FriendInvitation(id: UUID().uuidString, senderID: senderID, receiverID: receiverID, status: .pending)
        
        invitations.append(newInvitation)
        
        print("Einladung von \(senderID) an \(receiverID) wurde gesendet.")
    }

    func getInvitationFromDatabase(invitationID: String) -> FriendInvitation? {
        return invitations.first { $0.id == invitationID }
    }

    func saveInvitationToDatabase(invitation: FriendInvitation) {
        print("Einladung gespeichert für \(invitation.senderID) an \(invitation.receiverID).")
    }

    func acceptFriendRequest(invitationID: String) {
        if let invitationIndex = invitations.firstIndex(where: { $0.id == invitationID }) {
            invitations[invitationIndex].status = .accepted
            saveInvitationToDatabase(invitation: invitations[invitationIndex])
            
            print("Einladung von \(invitations[invitationIndex].senderID) akzeptiert.")
        }
    }
    
    func rejectFriendRequest(invitationID: String) {
        if let invitationIndex = invitations.firstIndex(where: { $0.id == invitationID }) {
            invitations[invitationIndex].status = .rejected
            saveInvitationToDatabase(invitation: invitations[invitationIndex])
            
            print("Einladung abgelehnt.")
        }
    }
    
    func sendMessage(from senderID: String, to receiverID: String, message: String) {
        if areFriends(senderID: senderID, receiverID: receiverID) {
            print("Nachricht von \(senderID) an \(receiverID): \(message)")
        } else {
            print("Freundschaft muss erst akzeptiert werden, bevor Nachrichten gesendet werden können.")
        }
    }

    func areFriends(senderID: String, receiverID: String) -> Bool {
        return checkFriendshipStatus(senderID: senderID, receiverID: receiverID) == .accepted
    }

    func checkFriendshipStatus(senderID: String, receiverID: String) -> InvitationStatus {
        if let invitation = invitations.first(where: { ($0.senderID == senderID && $0.receiverID == receiverID) || ($0.senderID == receiverID && $0.receiverID == senderID) }) {
            return invitation.status
        }
        return .pending
    }
}
