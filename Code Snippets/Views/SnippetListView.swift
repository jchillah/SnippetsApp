import SwiftUI

struct SnippetListView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject private var snippetViewModel = SnippetViewModel()
    @State private var title: String = ""
    @State private var code: String = ""
    @State private var selectedSnippet: Snippet?
    @State private var isSheetPresented: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if let user = userViewModel.user {
                    TextField("Snippet Title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextEditor(text: $code)
                        .frame(height: 100)
                        .border(Color.gray, width: 1)
                        .padding(.horizontal)

                    Button(action: {
                        guard !title.isEmpty, !code.isEmpty else {
                            snippetViewModel.errorMessage = "Title and code cannot be empty."
                            return
                        }

                        if let userId = user.id {
                            isLoading = true
                            snippetViewModel.addSnippet(userId: userId, title: title, code: code) { success in
                                if success {
                                    title = ""
                                    code = ""
                                }
                                isLoading = false
                            }
                        }
                    }) {
                        Text("Add Snippet")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()

                    if isLoading {
                        ProgressView("Saving...")
                            .padding()
                    }

                    List(snippetViewModel.snippets) { snippet in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(snippet.title)
                                    .font(.headline)
                                Text(snippet.code)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                            Spacer()
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let user = userViewModel.user {
                                    snippetViewModel.deleteSnippet(userId: user.id!, id: snippet.id!) { success in
                                        if success {
                                            snippetViewModel.fetchSnippets(for: user.id!)
                                        }
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            selectedSnippet = snippet
                            isSheetPresented = true
                            snippetViewModel.fetchSnippets(for: snippet.id!)
                        }
                    }
                    .onAppear {
                        if let userId = user.id {
                            snippetViewModel.fetchSnippets(for: userId)
                        }
                    }
                    .onDisappear {
                        snippetViewModel.clearListener()
                    }

                    if let successMessage = snippetViewModel.successMessage {
                        Text(successMessage)
                            .foregroundColor(.green)
                            .padding()
                    }

                    if let errorMessage = snippetViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                } else {
                    Text("Please log in to view snippets.")
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: {
                selectedSnippet = nil
            }) {
                if let snippet = selectedSnippet {
                    SnippetDetailView(snippet: Binding(
                        get: { snippet },
                        set: { selectedSnippet = $0 }
                    ), snippetViewModel: snippetViewModel)
                }
            }
        }
    }
}

#Preview {
    SnippetListView()
        .environmentObject(UserViewModel())
}
