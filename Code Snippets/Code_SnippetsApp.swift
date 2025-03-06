import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct Code_SnippetsApp: App {
    @StateObject private var userViewModel = UserViewModel()
    
    

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if userViewModel.isUserLoggedIn {
                MainTabView()
                    .environmentObject(userViewModel)
                    
            } else {
                LoginView()
                    .environmentObject(userViewModel)
            }
        }
    }
}

