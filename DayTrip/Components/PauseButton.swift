//
//  PauseButton.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct PauseButton: View {
    @EnvironmentObject var manager: LocationManager

    var body: some View {
        Button("Pause", systemImage: "pause.fill") {
            manager.pause()
        }
        .labelStyle(.iconOnly)
        .padding(12)
        .background {
            Circle()
                .fill(.foreground.quinary)
        }
        .disabled(manager.status != .recording)
    }
}

#Preview {
    PauseButton()
        .environmentObject(LocationManager())
}
