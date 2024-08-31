//
//  OnSwipeModifier.swift
//  DayTrip
//
//  Created by Stef Kors on 21/08/2024.
//


import SwiftUI
import SwiftData
import MapKit
import Foundation

extension FloatingPoint {
    func clamped(lower: Self, upper: Self) -> Self {
        return max(min(self, upper), lower)
    }

    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(min(self, range.upperBound), range.lowerBound)
    }
}


extension BinaryInteger {
    func clamped(lower: Self, upper: Self) -> Self {
        return max(min(self, upper), lower)
    }

    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(min(self, range.upperBound), range.lowerBound)
    }
}

struct OnSwipeWithRubberBandingModifier: ViewModifier {
    var onSwipeUp: () -> Void = {  }
    var onSwipeDown: () -> Void = {  }
    var onSwipeLeft: () -> Void = {  }
    var onSwipeRight: () -> Void = {  }

    var horizontalEnabled = false
    var verticalEnabled = true

    @State private var called: Bool = false

    @State private var yTranslation: CGFloat = .zero
    @State private var yScaling: CGFloat = 1

    @State private var xTranslation: CGFloat = .zero
    @State private var xScaling: CGFloat = 1

    @State private var dragLimit: CGFloat = 10



    func body(content: Content) -> some View {
        content
            .offset(x: xTranslation, y: yTranslation)
            .scaleEffect(x: xScaling, y: yScaling)
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onChanged({ value in
                    handleRubberBanding(value)

                    guard called == false else { return }
                    called = true
                    handleCallback(value)
                })
                .onEnded { value in
                    called = false
                    withAnimation(.spring()) {
                        yTranslation = .zero
                        xTranslation = .zero
                        yScaling = 1
                        xScaling = 1
                    }
            })
    }

    func handleRubberBanding(_ value: DragGesture.Value) {
        if verticalEnabled {
            let velocityBanding = ((value.velocity.height/10000) * -1).clamped(lower: -0.12, upper: 0.12)

            if value.translation.height >= dragLimit {
                // hits limit
                yTranslation = dragLimit * (1.00 + log10(value.translation.height / dragLimit))
                withAnimation(.spring(blendDuration: 300)) {
                    yScaling = 1 + velocityBanding
                }
            } else if value.translation.height <= (dragLimit * -1) {
                // below limit
                yTranslation = (dragLimit * -1) * (1.00 + log10(value.translation.height / (dragLimit * -1)))
                withAnimation(.spring(blendDuration: 300)) {
                    yScaling = 1 + velocityBanding
                }
            } else {
                // limiter
                yTranslation = value.translation.height
            }
        }

        if horizontalEnabled {
            let velocityBanding = ((value.velocity.width/10000) * -1).clamped(lower: -0.12, upper: 0.12)

            if value.translation.width >= dragLimit {
                xTranslation = dragLimit * (1.00 + log10(value.translation.width / dragLimit))
                withAnimation(.spring(blendDuration: 300)) {
                    xScaling = 1 + velocityBanding
                }
            } else if value.translation.width <= (dragLimit * -1) {
                xTranslation = (dragLimit * -1) * (1.00 + log10(value.translation.width / (dragLimit * -1)))
                withAnimation(.spring(blendDuration: 300)) {
                    xScaling = 1 + velocityBanding
                }
            } else {
                xTranslation = value.translation.width
            }
        }
    }

    func handleCallback(_ value: DragGesture.Value) {
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height

        if abs(horizontalAmount) > abs(verticalAmount) {
            if horizontalAmount < 0 {
                onSwipeLeft()
            } else {
                onSwipeRight()
            }
        } else {
            if verticalAmount < 0 {
                onSwipeUp()
            } else {
                onSwipeDown()
            }
        }
    }
}

extension View {
    func OnSwipeWithRubberBanding(
        onSwipeUp: @escaping () -> Void = {  },
        onSwipeDown: @escaping () -> Void = {  },
        onSwipeLeft: @escaping () -> Void = {  },
        onSwipeRight: @escaping () -> Void = {  },
        horizontalEnabled: Bool = false,
        verticalEnabled: Bool = true
    ) -> some View {
        modifier(
            OnSwipeWithRubberBandingModifier(
                onSwipeUp: onSwipeUp,
                onSwipeDown: onSwipeDown,
                onSwipeLeft: onSwipeLeft,
                onSwipeRight: onSwipeRight,
                horizontalEnabled: horizontalEnabled,
                verticalEnabled: verticalEnabled
            )
        )
    }
}
