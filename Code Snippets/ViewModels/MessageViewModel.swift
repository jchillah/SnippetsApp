import Foundation
import Combine
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private let apiURL = "https://yourapi.com/messages"

    func sendMessage(sender: String, content: String) {
        let message = Message(id: UUID().uuidString, sender: sender, content: content, timestamp: Date())
        
        do {
            _ = try db.collection("messages").document(message.id).setData(from: message)
        } catch {
            print("Error sending message: \(error)")
        }
    }

    func fetchMessages() {
        db.collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener
        { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                self.messages = snapshot?.documents.compactMap { document in
                    try? document.data(as: Message.self)
                } ?? []
            }
    }
    
    func deleteMessage(at indexSet: IndexSet) {
            messages.remove(atOffsets: indexSet)
        }
    
    
}
