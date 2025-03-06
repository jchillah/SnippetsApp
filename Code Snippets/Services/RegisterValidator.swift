//
//  RegisterValidator.swift
//  Code Snippets
//
//  Created by Michael Winkler on 31.01.25.
//

import Foundation

enum ValidationError: Error {
    case underage
    case invalidPassword
    case invalidEmail
}

class RegisterValidator {
    /// Überprüft, ob das Alter des Nutzers gültig ist.
    /// - Parameter birthDate: Das Geburtsdatum des Nutzers.
    /// - Returns: `true`, wenn das Alter gültig ist; andernfalls `false`.
    static func isAgeValid(birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let age = calendar.dateComponents([.year], from: birthDate, to: currentDate).year ?? 0
        return age >= 12
    }

    /// Überprüft, ob das Passwort den Anforderungen entspricht.
    /// - Parameter password: Das Passwort des Nutzers.
    /// - Returns: `true`, wenn das Passwort gültig ist; andernfalls `false`.
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    /// Überprüft, ob die E-Mail-Adresse gültig ist.
    /// - Parameter email: Die E-Mail-Adresse des Nutzers.
    /// - Returns: `true`, wenn die E-Mail-Adresse gültig ist; andernfalls `false`.
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
