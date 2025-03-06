//
//  InvitationStatus.swift
//  Code Snippets
//
//  Created by Michael Winkler on 06.03.25.
//

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
