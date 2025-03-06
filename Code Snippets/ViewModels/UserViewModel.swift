import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserViewModel: ObservableObject {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    @Published var user: User?
    @Published var errorMessage: String?

    @Published var firstName = "" { didSet { validateForm() } }
    @Published var lastName = "" { didSet { validateForm() } }
    @Published var email = "" { didSet { validateForm() } }
    @Published var password = "" { didSet { validateForm() } }
    @Published var confirmPassword = "" { didSet { validateForm() } }
    @Published var birthDate: Date = Calendar.current.date(byAdding: .year, value: -12, to: Date()) ?? Date()
    @Published var gender = ""
    @Published var profession = ""
    @Published var isFormValid = false

    var minDate: Date { Calendar.current.date(byAdding: .year, value: -100, to: Date()) ?? Date() }
    var maxDate: Date { Calendar.current.date(byAdding: .year, value: -12, to: Date()) ?? Date() }

    init() {
        checkUserStatus()
    }

    var isUserLoggedIn: Bool {
        user != nil
    }

    func register() {
        guard isFormValid else { return }
        
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async { self.setError("Registration failed: \(error.localizedDescription)") }
                return
            }
            if let userId = authResult?.user.uid {
                self.createUser(id: userId)
            }
        }
    }

    func createUser(id: String) {
        db.collection("users").document(id).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async { self.setError("Error fetching user: \(error.localizedDescription)") }
                return
            }

            if document?.exists == true {
                self.fetchUser(id: id)
            } else {
                let newUser = User(
                    id: id,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    gender: self.gender,
                    birthDate: self.birthDate,
                    profession: self.profession,
                    registeredOn: nil
                )

                do {
                    try self.db.collection("users").document(id).setData(from: newUser) { error in
                        if let error = error {
                            DispatchQueue.main.async { self.setError("Error saving user: \(error.localizedDescription)") }
                        } else {
                            DispatchQueue.main.async { self.fetchUser(id: id) }
                        }
                    }
                } catch {
                    DispatchQueue.main.async { self.setError("Error encoding user: \(error.localizedDescription)") }
                }
            }
        }
    }

    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async { self.setError("Login failed: \(error.localizedDescription)") }
                return
            }
            if let userId = authResult?.user.uid {
                self.fetchUser(id: userId)
            }
        }
    }

    func logout() {
        do {
            try auth.signOut()
            DispatchQueue.main.async { self.user = nil }
        } catch {
            DispatchQueue.main.async { self.setError("Logout failed: \(error.localizedDescription)") }
        }
    }

    func loginAnonymously() {
        auth.signInAnonymously { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async { self.setError("Anonymous login failed: \(error.localizedDescription)") }
                return
            }
            if let userId = authResult?.user.uid {
                self.db.collection("users").document(userId).getDocument { [weak self] document, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self.setError("Error checking user document: \(error.localizedDescription)")
                        }
                        return
                    }

                    if document?.exists == false {
                        let newUser = User(
                            id: userId,
                            firstName: "Anonymous",
                            lastName: "",
                            gender: "",
                            birthDate: Date(),
                            profession: "",
                            registeredOn: nil
                        )

                        do {
                            try self.db.collection("users").document(userId).setData(from: newUser) { error in
                                if let error = error {
                                    DispatchQueue.main.async { self.setError("Error saving user: \(error.localizedDescription)") }
                                } else {
                                    self.fetchUser(id: userId)
                                }
                            }
                        } catch {
                            DispatchQueue.main.async { self.setError("Error encoding user: \(error.localizedDescription)") }
                        }
                    } else {
                        self.fetchUser(id: userId)
                    }
                }
            }
        }
    }

    func fetchUser(id: String) {
        db.collection("users").document(id).getDocument(as: User.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.setError("Error loading user: \(error.localizedDescription)")
                    self.user = nil
                }
            }
        }
    }

    func validateForm() {
        errorMessage = nil
        
        if !isAllRequiredFieldsFilled() {
            isFormValid = false
            return
        }

        if !isUserOldEnough() {
            isFormValid = false
            return
        }

        if !doPasswordsMatch() {
            isFormValid = false
            return
        }

        if !isPasswordStrong() {
            isFormValid = false
            return
        }

        if !RegisterValidator.isEmailValid(email) {
            setError("Invalid email format.")
            isFormValid = false
            return
        }

        isFormValid = true
    }

    private func isAllRequiredFieldsFilled() -> Bool {
        if firstName.isEmpty || lastName.isEmpty || gender.isEmpty {
            setError("All fields are required.")
            return false
        }
        return true
    }

    private func isUserOldEnough() -> Bool {
        if birthDate > maxDate {
            setError("You must be at least 12 years old.")
            return false
        }
        return true
    }

    private func doPasswordsMatch() -> Bool {
        if password != confirmPassword {
            setError("Passwords do not match.")
            return false
        }
        return true
    }

    private func isPasswordStrong() -> Bool {
        if !RegisterValidator.isPasswordValid(password) {
            setError("Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character.")
            return false
        }
        return true
    }

    private func setError(_ message: String) {
        errorMessage = message
    }

    func checkUserStatus() {
        if let currentUser = auth.currentUser {
            fetchUser(id: currentUser.uid)
        } else {
            user = nil
        }
    }
}
