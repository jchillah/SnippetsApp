import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome to Code Snippets")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                if let user = userViewModel.user {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("👤 Name:")
                                .fontWeight(.bold)
                            Text("\(user.firstName) \(user.lastName)")
                        }
                        
                        HStack {
                            Text("📅 Birthday:")
                                .fontWeight(.bold)
                            Text("\(formattedDate(user.birthDate))")
                        }
                        
                        HStack {
                            Text("📝 Job:")
                                .fontWeight(.bold)
                            Text(user.profession)
                        }
                        
                        HStack {
                            Text("📆 Registered on:")
                                .fontWeight(.bold)
                            Text("\(formattedDate(user.registeredOn!))")
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    .padding(.horizontal)
                } else {
                    Text("No user logged in")
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    userViewModel.logout()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Logout")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all) 
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    HomeView()
        .environmentObject(UserViewModel())
}
