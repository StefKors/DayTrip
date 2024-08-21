//
//  StatusIndicator.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct StatusIndicator: View {
    @EnvironmentObject var manager: LocationManager



    var body: some View {
        HStack {
            StatusIndicatorLight(isAnimating: manager.status == .recording)

            Text("\(manager.status.rawValue.capitalized)")
                .contentTransition(.numericText())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.foreground.quinary)
        }
    }
}

#Preview {
    StatusIndicator()
        .environmentObject(LocationManager())
}
