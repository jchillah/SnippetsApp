import SwiftUI
import FirebaseFirestore

struct MainTabView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var navigateToLoginView = false

    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                SnippetListView()
                    .tabItem {
                        Label("Snippet", systemImage: "note.text")
                    }
                
                MessagesView()
                    .tabItem {
                        Label("Messages", systemImage: "message")
                    }
                
                FriendListView()
                    .tabItem {
                        Label("Freunde", systemImage: "person.3.fill")
                            .foregroundColor(.orange)
                    }
            }
            .onAppear {
                // Überprüfen, ob der Benutzer eingeloggt ist, und ggf. zur Login-Ansicht navigieren
                if !viewModel.isUserLoggedIn {
                    navigateToLoginView = true
                }
            }
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(UserViewModel())
}
