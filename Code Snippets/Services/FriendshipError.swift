// Errors.swift

/// Fehler, die beim Verwalten von Freundschaften auftreten können.
enum FriendshipError: Error {
    case invalidUserId
    case networkError
}

/// Fehler, die bei der Validierung von Registrierungsdaten auftreten können.
enum ValidationError: Error, LocalizedError {
    case invalidEmail
    case passwordTooShort

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Die E-Mail-Adresse ist ungültig."
        case .passwordTooShort:
            return "Das Passwort muss mindestens 6 Zeichen lang sein."
        }
    }
}
