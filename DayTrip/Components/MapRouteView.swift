//
//  MapRouteView.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct MapRouteView: View {
    @EnvironmentObject var manager: LocationManager

    @State private var region: MapCameraPosition = MapCameraPosition.automatic

    var body: some View {
        Map(position: $region) {
            if manager.points.isEmpty == false {
                MapPolyline(coordinates: manager.points, contourStyle: .geodesic)
                    .stroke(.purple, lineWidth: 4)
            }

            if let location = manager.currentLocation {
                Marker("current", systemImage: "location.fill", coordinate: location.coordinate)
            }
        }
        .mapControlVisibility(.visible)
        .edgesIgnoringSafeArea(.all)

    }
}

#Preview {
    MapRouteView()
        .environmentObject(LocationManager())
}
