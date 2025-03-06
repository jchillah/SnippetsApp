import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToMainTabView: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to Code Snippets!")
                    .font(.largeTitle)
                    .bold()

                TextField("E-Mail", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button(action: {
                    viewModel.login(email: email, password: password)
                    if viewModel.isUserLoggedIn {
                        navigateToMainTabView = true
                    }
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                NavigationLink("Not yet registered? Register here", destination: RegisterView())
                    .font(.subheadline)
                    .foregroundColor(.blue)

                Divider()
                    .padding(.vertical)

                Button(action: {
                    viewModel.loginAnonymously()
                    if viewModel.isUserLoggedIn {
                        navigateToMainTabView = true
                    }
                }) {
                    Text("Login Anonymously")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.checkUserStatus()
            }
            .navigationDestination(isPresented: $navigateToMainTabView) {
                MainTabView()
                    .environmentObject(viewModel)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
