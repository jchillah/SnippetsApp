import Foundation

/// Fehler, die während des Freundschaftsmanagements auftreten können.
///
/// - invalidUserId: Die angegebene Nutzer-ID ist ungültig.
/// - invitationNotFound: Die Einladung wurde nicht gefunden.
/// - alreadyFriends: Die Nutzer sind bereits befreundet.
/// - networkError: Es ist ein Netzwerkfehler aufgetreten.
enum FriendshipError: Error {
    case invalidUserId
    case invitationNotFound
    case alreadyFriends
    case networkError
}

/// Verwaltet Freundschaftsbeziehungen und -einladungen zwischen Nutzern.
class FriendshipManager: ObservableObject {
    /// Eine Liste aller Freundschaftseinladungen.
    @Published var invitations: [FriendInvitation] = []
    
    /// Sendet eine Freundschaftsanfrage von einem Sender zu einem Empfänger.
    ///
    /// - Parameters:
    ///   - senderID: Die ID des sendenden Nutzers.
    ///   - receiverID: Die ID des empfangenden Nutzers.
    ///   - completion: Ein Completion-Handler, der das Ergebnis der Anfrage zurückgibt.
    func sendFriendRequest(from senderID: String, to receiverID: String, completion: @escaping (Result<Void, FriendshipError>) -> Void) {
        // Überprüfe, ob die Nutzer-IDs gültig sind.
        guard !senderID.isEmpty, !receiverID.isEmpty else {
            completion(.failure(.invalidUserId))
            return
        }
        func sendFriendRequest(from senderID: String, to receiverID: String) {
            let newInvitation = FriendInvitation(id: UUID().uuidString, senderID: senderID, receiverID: receiverID, status: .pending)
            
            invitations.append(newInvitation)
            
            print("Einladung von \(senderID) an \(receiverID) wurde gesendet.")
        }
        // Überprüfe, ob bereits eine Freundschaft besteht.
        if areFriends(senderID: senderID, receiverID: receiverID) {
            completion(.failure(.alreadyFriends))
            return
        }
        
        let newInvitation = FriendInvitation(id: UUID().uuidString, senderID: senderID, receiverID: receiverID, status: .pending)
        invitations.append(newInvitation)
        saveInvitationToDatabase(invitation: newInvitation)
        
        print("Einladung von \(senderID) an \(receiverID) wurde gesendet.")
        completion(.success(()))
    }
    
    /// Akzeptiert eine Freundschaftsanfrage.
    ///
    /// - Parameters:
    ///   - invitationID: Die ID der Einladung.
    ///   - completion: Ein Completion-Handler, der das Ergebnis der Aktion zurückgibt.
    func acceptFriendRequest(invitationID: String, completion: @escaping (Result<Void, FriendshipError>) -> Void) {
        if let invitationIndex = invitations.firstIndex(where: { $0.id == invitationID }) {
            invitations[invitationIndex].status = .accepted
            saveInvitationToDatabase(invitation: invitations[invitationIndex])
            
            print("Einladung von \(invitations[invitationIndex].senderID) akzeptiert.")
            completion(.success(()))
        } else {
            completion(.failure(.invitationNotFound))
        }
    }
    
    /// Lehnt eine Freundschaftsanfrage ab.
    ///
    /// - Parameters:
    ///   - invitationID: Die ID der Einladung.
    ///   - completion: Ein Completion-Handler, der das Ergebnis der Aktion zurückgibt.
    func rejectFriendRequest(invitationID: String, completion: @escaping (Result<Void, FriendshipError>) -> Void) {
        if let invitationIndex = invitations.firstIndex(where: { $0.id == invitationID }) {
            invitations[invitationIndex].status = .rejected
            saveInvitationToDatabase(invitation: invitations[invitationIndex])
            
            print("Einladung abgelehnt.")
            completion(.success(()))
        } else {
            completion(.failure(.invitationNotFound))
        }
    }
    
    /// Sendet eine Nachricht von einem Sender zu einem Empfänger.
    ///
    /// - Parameters:
    ///   - senderID: Die ID des sendenden Nutzers.
    ///   - receiverID: Die ID des empfangenden Nutzers.
    ///   - message: Der Inhalt der Nachricht.
    func sendMessage(from senderID: String, to receiverID: String, message: String) {
        if areFriends(senderID: senderID, receiverID: receiverID) {
            print("Nachricht von \(senderID) an \(receiverID): \(message)")
        } else {
            print("Freundschaft muss erst akzeptiert werden, bevor Nachrichten gesendet werden können.")
        }
    }
    
    /// Überprüft, ob zwei Nutzer befreundet sind.
    ///
    /// - Parameters:
    ///   - senderID: Die ID des ersten Nutzers.
    ///   - receiverID: Die ID des zweiten Nutzers.
    /// - Returns: Ein Boolescher Wert, der angibt, ob die Nutzer befreundet sind.
    func areFriends(senderID: String, receiverID: String) -> Bool {
        return checkFriendshipStatus(senderID: senderID, receiverID: receiverID) == .accepted
    }
    
    /// Überprüft den Freundschaftsstatus zwischen zwei Nutzern.
    ///
    /// - Parameters:
    ///   - senderID: Die ID des ersten Nutzers.
    ///   - receiverID: Die ID des zweiten Nutzers.
    /// - Returns: Der aktuelle Einladungsstatus zwischen den Nutzern.
    func checkFriendshipStatus(senderID: String, receiverID: String) -> InvitationStatus {
        if let invitation = invitations.first(where: { ($0.senderID == senderID && $0.receiverID == receiverID) || ($0.senderID == receiverID && $0.receiverID == senderID) }) {
            return invitation.status
        }
        return .pending
    }
    
    /// Ruft eine Einladung aus der Datenbank ab.
    ///
    /// - Parameter invitationID: Die ID der Einladung.
    /// - Returns: Die entsprechende Freundschaftseinladung oder nil, wenn sie nicht gefunden wurde.
    func getInvitationFromDatabase(invitationID: String) -> FriendInvitation? {
        return invitations.first { $0.id == invitationID }
    }
    
    /// Speichert eine Einladung in der Datenbank.
    ///
    /// - Parameter invitation: Die zu speichernde Freundschaftseinladung.
    func saveInvitationToDatabase(invitation: FriendInvitation) {
        print("Einladung gespeichert")
    }
}
 
