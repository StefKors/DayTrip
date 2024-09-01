//
//  TrackingRouteView.swift
//  DayTrip
//
//  Created by Stef Kors on 31/08/2024.
//

import SwiftUI
import SwiftData


struct TrackingRouteView: View {
    @EnvironmentObject private var manager: LocationManager

    @Query private var routes: [Route]

    var body: some View {
        VStack {
            ForEach(routes) { route in
                Path { path in
                    if let first = route.points.first {
                        path.move(to: CGPoint(x: first.latitude, y: first.longitude))
                    }
                    for point in route.points {
                        path.addLine(to: CGPoint(x: point.latitude, y: point.longitude))
                    }

                    //                path.addLine(to: CGPoint(x: 100, y: 300))
                    //                path.addLine(to: CGPoint(x: 300, y: 300))
                    //                path.addLine(to: CGPoint(x: 200, y: 100))
                }
                .strokedPath(.init(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .scaledToFit()
                .aspectRatio(1.5, contentMode: .fit)
            }
        }
    }
}

#Preview {
    TrackingRouteView()
        .environmentObject(LocationManager())
        .modelContainer(DataController.previewContainer)
}
