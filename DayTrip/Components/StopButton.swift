//
//  StopButton.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct StopButton: View {
    @EnvironmentObject var manager: LocationManager

    var body: some View {
        Button("Stop", systemImage: "stop.fill") {
            manager.stop()
        }
        .labelStyle(.iconOnly)
        .padding(12)
        .background {
            Circle()
                .fill(.foreground.quinary)
        }
    }
}

#Preview {
    StopButton()
        .environmentObject(LocationManager())
}
