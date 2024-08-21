//
//  StatusIndicatorLight.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct StatusIndicatorLight: View {
    var isAnimating: Bool = false

    var body: some View {
        ZStack {
            if isAnimating {
                AnimatedStatusIndicatorLight()
                    .transition(.opacity)
            } else {
                StaticStatusIndicatorLight()
                    .transition(.opacity)
            }
        }
        .animation(.smooth, value: isAnimating)
    }
}

#Preview {
    StatusIndicatorLight(isAnimating: true)
}
