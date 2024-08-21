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

    var region: MapCameraPosition {
        MapCameraPosition.region(
            manager.region
        )
    }

    let montblanc = CLLocationCoordinate2D(latitude: 45.832119, longitude: 6.865575)

    var body: some View {
        Map(initialPosition: region) {
            MapPolyline(coordinates: manager.points, contourStyle: .geodesic)
                .stroke(.purple, lineWidth: 4)
        }
        .mapControlVisibility(.hidden)
        .edgesIgnoringSafeArea(.all)
    }
}
