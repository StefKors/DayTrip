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
    case nopermission
}

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()

    @Published var status: RecordingStatus = .ready

    @Published var points: [CLLocationCoordinate2D] = []

    @Published var currentLocation: CLLocation? = nil

    @Published var speed: CLLocationSpeed = 0


    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 37.334_900, longitude: -122.009_020),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )


    override init() {
        super.init()

        self.locationManager.delegate = self
        setup()
    }

    func setup() {
        let authorizationStatus = locationManager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            self.locationManager.startUpdatingLocation()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
        case .authorizedAlways:
            print("authorizedAlways")
            self.locationManager.startUpdatingLocation()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
        case .notDetermined:
            print("notDetermined")
            self.locationManager.requestLocation()
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        default:
            print("unknown")
        }

    }

    func start() {
        status = .recording
    }

    func pause() {
//        locationManager.stopUpdatingLocation()
        status = .paused
    }

    func stop() {
//        locationManager.stopUpdatingLocation()
        status = .stopped
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        withAnimation(.interactiveSpring) {
            if let lastLocation = locations.last {
                print("updating speed and location")
                self.speed = lastLocation.speed
                self.currentLocation = lastLocation
            }
            if self.status == .recording {
                let coords = locations.map { loc in
                    return loc.coordinate
                }
                if !coords.isEmpty {
                    print("adding points")
                    self.points.append(contentsOf: coords)
                }
            }
        }
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        status = .paused
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        status = .recording
    }
}
