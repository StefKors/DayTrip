//
//  LocationManager.swift
//  DayTrip
//
//  Source: https://medium.com/@pblanesp/how-to-display-a-map-and-track-the-users-location-in-swiftui-7d288cdb747e
//
//  Created by Stef Kors on 20/08/2024.
//


import MapKit
import SwiftUI

enum RecordingStatus: String {
    case ready
    case recording
    case stopped
    case paused
}

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var status: RecordingStatus = .stopped

    @Published var points: [CLLocationCoordinate2D] = [
        .init(latitude: 37.334_900, longitude: -122.009_020)
    ]

    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 37.334_900, longitude: -122.009_020),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.setup()
    }

    func setup() {
        print("setup", locationManager.authorizationStatus)
        self.start()
    }

    func start() {
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        status = .recording
    }

    func pause() {
        locationManager.stopUpdatingLocation()
        status = .paused
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        status = .stopped
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("adding points")
        let coords = locations.map { loc in
            return loc.coordinate
        }

        print("adding points", coords)
        withAnimation(.interactiveSpring) {
            points.append(contentsOf: coords)
        }
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        status = .paused
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        status = .recording
    }
}
