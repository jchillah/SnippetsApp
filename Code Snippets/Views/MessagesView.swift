import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var messageViewModel = MessageViewModel()
    @State private var newMessageContent: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(messageViewModel.messages) { message in
                    VStack(alignment: .leading) {
                        Text(message.sender)
                            .font(.headline)
                        Text(message.content)
                            .font(.body)
                            .foregroundColor(.gray)
                        Text(formattedDate(message.timestamp))
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                .onDelete(perform: delete)
            }
            
            HStack {
                TextField("Enter message", text: $newMessageContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Send") {
                    if let user = userViewModel.user {
                        messageViewModel.sendMessage(sender: "\(user.firstName) \(user.lastName)", content: newMessageContent)
                        newMessageContent = ""
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            messageViewModel.fetchMessages()
        }
    }

    func delete(at offsets: IndexSet) {
        messageViewModel.deleteMessage(at: offsets)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MessagesView()
        .environmentObject(UserViewModel())
}
