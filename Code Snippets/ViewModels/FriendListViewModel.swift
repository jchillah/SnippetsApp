import Foundation

class FriendListViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    
    func fetchFriends() {
        // Hier solltest du deine Firebase oder eine andere Quelle verwenden, um die Freunde zu laden.
        // Für die Demo verwenden wir Dummy-Daten:
        
        friends = [
            Friend(id: "1", name: "Max Mustermann", email: "max@example.com"),
            Friend(id: "2", name: "Julia Meyer", email: "julia@example.com"),
            Friend(id: "3", name: "Anna Schmitz", email: "anna@example.com")
        ]
    }
}
