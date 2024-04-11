import SwiftUI
import Foundation

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: EditViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("New Location", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Loading") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline) + Text(": ") + Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading")
                    case .failed:
                        Text("Failed")
                    }
                }
            }
            .navigationTitle("Edit")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
            .task  {
               await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self._viewModel = StateObject(wrappedValue: EditViewModel(location: location, onSave: onSave))
    }
}

