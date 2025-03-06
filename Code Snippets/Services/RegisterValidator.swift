//
//  RegisterValidator.swift
//  Code Snippets
//
//  Created by Michael Winkler on 31.01.25.
//

import Foundation

class RegisterValidator {
    static func isAgeValid(birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let age = calendar.dateComponents([.year], from: birthDate, to: currentDate).year ?? 0
        return age >= 12
    }

    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    static func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
