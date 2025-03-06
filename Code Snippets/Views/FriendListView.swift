import SwiftUI

struct FriendListView: View {
    @StateObject private var friendListViewModel = FriendListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Meine Freunde")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                List(friendListViewModel.friends) { friend in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(friend.name)
                                .font(.headline)
                            Text(friend.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(friend.id)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                .onAppear {
                    friendListViewModel.fetchFriends()
                }
            }
            .padding()
            .navigationTitle("Freunde")
        }
    }
}

#Preview {
    FriendListView()
}
