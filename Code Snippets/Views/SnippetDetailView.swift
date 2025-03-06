import SwiftUI

struct SnippetDetailView: View {
    @Binding var snippet: Snippet
    @ObservedObject var snippetViewModel: SnippetViewModel
    @State private var title: String
    @State private var code: String
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    init(snippet: Binding<Snippet>, snippetViewModel: SnippetViewModel) {
        _snippet = snippet
        _title = State(initialValue: snippet.wrappedValue.title)
        _code = State(initialValue: snippet.wrappedValue.code)
        self.snippetViewModel = snippetViewModel
    }

    var body: some View {
        VStack {
            TextField("Snippet Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $code)
                .frame(height: 100)
                .border(Color.gray, width: 1)
                .padding()

            Button("Save Changes") {
                snippet.title = title
                snippet.code = code
                if let userId = userViewModel.user?.id, let snippetId = snippet.id {
                    snippetViewModel.updateSnippet(id: snippetId, userId: userId, title: title, code: code) { success in
                        if success {
                            dismiss()
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationTitle("Edit Snippet")
        .onDisappear {
            if let userId = userViewModel.user?.id {
                snippetViewModel.fetchSnippets(for: userId)
            }
        }

    }
}

struct SnippetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let userViewModel = UserViewModel()
        let snippet = Snippet(id: "1", title: "Sample Snippet", code: "print('Hello World')")
        let snippetViewModel = SnippetViewModel()

        SnippetDetailView(snippet: .constant(snippet), snippetViewModel: snippetViewModel)
            .environmentObject(userViewModel)
    }
}
