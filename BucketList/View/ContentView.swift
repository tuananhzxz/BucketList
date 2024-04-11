//
//  ContentView.swift
//  BucketList
//
//  Created by tuananhdo on 28/09/2023.
//

import MapKit
import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate){
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .background(.white)
                                .foregroundColor(.red)
                                .frame(width: 44,height: 44)
                                .clipShape(Circle())
                            
                            Text(location.name)
                        }
                        .onTapGesture {
                            viewModel.selectLocation = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32,height: 25)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            
                            viewModel.addLocation()
                            
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
                
                .sheet(item: $viewModel.selectLocation){ place in
                    EditView(location: place) { newLocation in
                        viewModel.updateLocation(location: newLocation)
                    }
                }
            }
        }
    }
//


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
