//
//  LocationNameView 2.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI
import CoreLocation

struct LocationNameView: View {
    let location: CLLocation?

    @State private var name: String? = nil

    var body: some View {
        VStack {
            if let name {
                Text(name)
                    .contentTransition(.numericText())
            }
        }
        .task(id: location) {
            if let name = try? await location?.readableName() {
                self.name = name
            }
        }
    }
}


#Preview {
    LocationNameView(location: SimpleCoordinate(latitude: 48.852972, longitude: 2.350004, name: "Notre-Dame Cathedral").location)
}
