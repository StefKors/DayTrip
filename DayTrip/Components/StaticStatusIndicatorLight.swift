//
//  StaticStatusIndicatorLight.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct StaticStatusIndicatorLight: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(.foreground.secondary)
            .opacity(1)
    }
}

#Preview {
    StaticStatusIndicatorLight()
}
