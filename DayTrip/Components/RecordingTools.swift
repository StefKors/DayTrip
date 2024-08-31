//
//  RecordingTools.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI

struct RecordingTools: View {
    @EnvironmentObject var manager: LocationManager

    var body: some View {
        HStack(spacing: 12) {
            StatusIndicator()

            VStack(alignment: .leading) {
                LocationNameView(location: manager.points.first?.toCLLocation())

                HStack {
                    DistanceView(distance: manager.points.totalDistance)

                    SpeedView(speed: manager.speed)
                }
            }
            .font(.caption2)


            Spacer()

            if (manager.status == .paused || manager.status == .ready) {
                PlayButton()
                    .transition(.slide.combined(with: .blurReplace))
            }

            if (manager.status == .recording) {
                PauseButton()
                    .transition(.slide.combined(with: .blurReplace))
            }

            if (manager.status == .paused) {
                StopButton()
                    .transition(.slide.combined(with: .blurReplace))
            }

            if (manager.status == .stopped) {
                SaveButton()
                    .transition(.slide.combined(with: .blurReplace))
            }
        }
    }
}

#Preview {
    RecordingTools()
        .environmentObject(LocationManager())
}
