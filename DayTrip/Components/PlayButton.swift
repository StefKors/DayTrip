//
//  PlayButton.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct PlayButton: View {
    @EnvironmentObject var manager: LocationManager

    var body: some View {
        Button("Start", systemImage: "play.fill") {
            manager.start()
        }
        .labelStyle(.iconOnly)
        .padding(12)
        .background {
            Circle()
                .fill(.foreground.quinary)
        }
        .disabled(manager.status == .recording)
    }
}

#Preview {
    PlayButton()
        .environmentObject(LocationManager())
}
