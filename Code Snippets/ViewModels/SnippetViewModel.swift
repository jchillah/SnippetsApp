import FirebaseFirestore
import SwiftUI

class SnippetViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    @Published var snippets: [Snippet] = []
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // Snippet hinzufügen
    func addSnippet(userId: String, title: String, code: String, completion: @escaping (Bool) -> Void) {
        let newSnippet: [String: Any] = [
            "userId": userId,
            "title": title,
            "code": code,
            "timestamp": Timestamp()
        ]
        
        db.collection("users").document(userId).collection("snippets").addDocument(data: newSnippet) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error saving snippet: \(error.localizedDescription)"
                    self.successMessage = nil
                    completion(false)
                } else {
                    self.successMessage = "Snippet saved successfully!"
                    self.errorMessage = nil
                    self.fetchSnippets(for: userId)  // Refresh list after saving
                    completion(true)
                }
            }
        }
    }
    
    // Snippet löschen
    func deleteSnippet(userId: String, id: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userId).collection("snippets").document(id).delete { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error deleting snippet: \(error.localizedDescription)"
                    self.successMessage = nil
                    completion(false)
                } else {
                    self.successMessage = "Snippet deleted successfully!"
                    self.errorMessage = nil
                    self.snippets.removeAll { $0.id == id }  // Update local list
                    completion(true)
                }
            }
        }
    }
    
    // Snippets für den Benutzer abrufen
    func fetchSnippets(for userId: String) {
        clearListener()
        listener = db.collection("users").document(userId).collection("snippets")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Error loading snippets: \(error.localizedDescription)"
                        return
                    }
                    self.snippets = snapshot?.documents.compactMap { document in
                        let data = document.data()
                        return Snippet(
                            id: document.documentID,
                            title: data["title"] as? String ?? "",
                            code: data["code"] as? String ?? ""
                        )
                    } ?? []
                }
            }
    }
    
    // Snippet aktualisieren
    func updateSnippet(id: String, userId: String, title: String, code: String, completion: @escaping (Bool) -> Void) {
        let updatedSnippet: [String: Any] = [
            "title": title,
            "code": code
        ]
        db.collection("users").document(userId).collection("snippets").document(id).updateData(updatedSnippet) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error updating snippet: \(error.localizedDescription)"
                    self.successMessage = nil
                    completion(false)
                } else {
                    self.successMessage = "Snippet updated successfully!"
                    self.errorMessage = nil
                    completion(true)
                }
            }
        }
    }
    
    // Listener entfernen
    func clearListener() {
        listener?.remove()
        listener = nil
    }
}
