import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
            // Image(systemName: "mic")  // Commented out to remove mic icon from search UI
        }
        .padding(8)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .padding()
    }
}
