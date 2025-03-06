//
//  FriendInvitation.swift
//  Code Snippets
//
//  Created by Michael Winkler on 06.03.25.
//

import Foundation

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


