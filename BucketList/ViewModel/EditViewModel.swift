//
//  EditViewModel.swift
//  BucketList
//
//  Created by tuananhdo on 11/4/24.
//

import Foundation
extension EditView {
    
    class EditViewModel : ObservableObject {
        
        // Khai báo DispatchQueue cho việc cập nhật trên luồng chính
        private let mainQueue = DispatchQueue.main
        
        enum LoadingState {
            case loading, loaded, failed
        }
        
        @Published var onSave : (Location) -> Void
        
        @Published var location : Location
        
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        
        @Published var name : String
        @Published var description : String
        
        init(location : Location, onSave : @escaping (Location) -> Void) {
            self.location = location
            self.onSave = onSave
            _name = Published(initialValue: location.name)
            _description = Published(initialValue: location.description)
        }
        
        func save(){
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            onSave(newLocation)
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                let items = try JSONDecoder().decode(Result.self, from: data)
                
                // Đảm bảo việc cập nhật pages và loadingState được thực hiện trên luồng chính
                mainQueue.async {
                    self.pages = items.query.pages.values.sorted()
                    self.loadingState = .loaded
                }
            } catch {
                // Đảm bảo việc cập nhật loadingState được thực hiện trên luồng chính
                mainQueue.async {
                    self.loadingState = .failed
                }
            }
        }
        
    }

}
