//
//  AnimatedStatusIndicatorLight.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct AnimationValues {
    var opacity = 0.2
}

struct AnimatedStatusIndicatorLight: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .keyframeAnimator(initialValue: AnimationValues()) { content, value in
                content
                    .foregroundStyle(Color.red)
                    .opacity(value.opacity)
            } keyframes: { _ in
                KeyframeTrack(\.opacity) {
                    LinearKeyframe(0.2, duration: 0.2)
                    CubicKeyframe(1, duration: 2.5)
                    CubicKeyframe(0.2, duration: 1.4)
                    LinearKeyframe(0.2, duration: 0.4)
                    LinearKeyframe(0.2, duration: 0.4)
                    LinearKeyframe(0.2, duration: 0.4)
                }
            }
    }
}
