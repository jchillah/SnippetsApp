import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var navigateToMainTabView = false
    
    let genders = ["Male", "Female", "Other"]
    let professions = ["Developer", "Designer", "Manager", "Other"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .bold()
                
                TextField("First Name", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Last Name", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("E-Mail", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                Picker("Gender", selection: $viewModel.gender) {
                    ForEach(genders, id: \.self) { Text($0) }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                DatePicker("Birth Date", selection: $viewModel.birthDate, in: viewModel.minDate...viewModel.maxDate, displayedComponents: .date)
                    .padding(.horizontal)
                
                Picker("Profession", selection: $viewModel.profession) {
                    ForEach(professions, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                HStack {
                    if isConfirmPasswordVisible {
                        TextField("Confirm Password", text: $viewModel.confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Button(action: { isConfirmPasswordVisible.toggle() }) {
                        Image(systemName: isConfirmPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.register()
                    if viewModel.isUserLoggedIn {
                        navigateToMainTabView = true
                    }
                }) {
                    Text("Register")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(!viewModel.isFormValid)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToMainTabView) {
                MainTabView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}
