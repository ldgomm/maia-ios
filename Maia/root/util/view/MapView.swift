//
//  MapView.swift
//  Maia
//
//  Created by José Ruiz on 29/7/24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    @State private var location: CLLocationCoordinate2D
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                Marker(coordinate: location) {
                    Text("You are here")
                }
            }
        }
    }
    
    init(location: CLLocationCoordinate2D) {
        _location = State(initialValue: location)
        _startPosition = State(wrappedValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
    }
}
