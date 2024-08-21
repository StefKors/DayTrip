//
//  Item.swift
//  DayTrip
//
//  Created by Stef Kors on 07/08/2024.
//

import Foundation
import SwiftData
import MapKit

extension Array where Element: CLLocation {

    /// Returns the total distance of the list of CLLocation objects.
    var totalDistance: CLLocationDistance {
        return reduce((0.0, nil), { ($0.0 + $1.distance(from: $0.1 ?? $1), $1) }).0
    }

}

extension Array {
    func asyncMap<T>(_ transform: (Element) async -> T) async -> [T] {
        var result: [T] = []
        for element in self {
            result.append(await transform(element))
        }
        return result
    }
}

struct SimpleCoordinate: Codable, Equatable {
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D {
    func toSimpleCoordinate() -> SimpleCoordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}

@Model
final class Route {
    var timestamp: Date

    var points: [SimpleCoordinate] = []

    var coordinates: [CLLocationCoordinate2D] {
        points.map(\.self).map(\.coordinate)
    }

    var locations: [CLLocation] {
        points.map(\.self).map(\.location)
    }

    var distance: CLLocationDistance {
        locations.totalDistance.rounded()
    }

    func name() async throws -> String {
        let names = try await readableNames()
        if let start = names.first {

            if let end = names.last {
                if start != end {
                    return "\(start) to \(end)"
                }
            }

            return start
        }

        return "Unknown"
    }

    func readableNames() async throws -> [String] {
        let coder = CLGeocoder()

        return await locations.asyncMap { location in

            if let placemark = try? await coder.reverseGeocodeLocation(location).first {

                // Try to get the most specific location name
                if let name = placemark.name, !(name.first?.isNumber ?? false) {
                    return name
                } else if let name = placemark.areasOfInterest?.first {
                    return name
                } else if let locality = placemark.locality {
                    return locality
                } else if let subLocality = placemark.subLocality {
                    return subLocality
                } else if let thoroughfare = placemark.thoroughfare {
                    return thoroughfare
                } else if let subThoroughfare = placemark.subThoroughfare {
                    return subThoroughfare
                } else if let country = placemark.country {
                    return country
                } else {
                    // If all else fails, use the coordinate description
                    return "\(String(describing: points.first?.latitude)), \(String(describing: points.first?.longitude))"
                }
            }

            return "Unknown"
        }
    }

    init(timestamp: Date = .now, points: [SimpleCoordinate] = []) {
        self.timestamp = timestamp
        self.points = points
    }
}

extension Route {
    static let preview: Route = Route(timestamp: .now, points: [
        SimpleCoordinate( latitude: 48.861950, longitude: 2.336902),
        SimpleCoordinate(latitude: 48.886634, longitude: 2.343048),
        SimpleCoordinate(latitude: 48.858258, longitude: 2.294488),
        SimpleCoordinate(latitude: 48.884134, longitude: 2.332196),
        SimpleCoordinate(latitude: 48.873776, longitude: 2.295043),
        SimpleCoordinate(latitude: 48.880071, longitude: 2.354977),
        SimpleCoordinate(latitude: 48.852972, longitude: 2.350004),
        SimpleCoordinate(latitude: 48.845616, longitude: 2.345996),
        ])

    static let preview2: Route = Route(timestamp: .now, points: [
        SimpleCoordinate( latitude: 46.63456170174721, longitude: 8.120240052866121),
        SimpleCoordinate(latitude: 46.64549835332431, longitude: 8.065101382247796),
        SimpleCoordinate(latitude: 46.629123624754, longitude: 8.043918171165004),
    ])

    static let preview3: Route = Route(timestamp: .now, points: [
        SimpleCoordinate( latitude: 52.073118327504424, longitude: 4.303814870162662),
        SimpleCoordinate(latitude: 52.0731183, longitude: 4.403814870162662)
    ])

}
