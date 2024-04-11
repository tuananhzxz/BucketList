//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by tuananhdo on 02/10/2023.
//

import Foundation
import MapKit
import LocalAuthentication

extension ContentView {
    @MainActor class ViewModel : ObservableObject {
        
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        
        @Published var selectLocation : Location?
        
        @Published private(set) var locations : [Location]
        
        @Published var isUnlock = false
        
        let savePath = FileManager.Documentdirectory.appendingPathExtension("SavePlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Error")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longtitude: mapRegion.center.longitude)
            
            locations.append(newLocation)
            
            DispatchQueue.main.async {
                self.save()
            }
        }
        
        func updateLocation(location : Location) {
            
            guard let selectLocation = selectLocation else { return }
            
            if let index = locations.firstIndex(of: selectLocation) {
                locations[index] = location
                
                // Sử dụng DispatchQueue.main.async để đảm bảo thay đổi được xuất từ luồng chính
                DispatchQueue.main.async {
                    self.save()
                }
            }
        }
        
        func authenticate() {
            
            let context = LAContext()
            var error : NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        // Sử dụng DispatchQueue.main.async để đảm bảo thay đổi được xuất từ luồng chính
                        DispatchQueue.main.async {
                            self.isUnlock = true
                        }
                    }
                    else
                    {
                        print(authenticationError?.localizedDescription ?? success)
                    }
                }
            }
            else {
                
            }
            
        }
    }
}
