//
//  OnSwipeModifier.swift
//  DayTrip
//
//  Created by Stef Kors on 21/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct OnSwipeModifier: ViewModifier {
    var onSwipeUp: () -> Void = {  }
    var onSwipeDown: () -> Void = {  }
    var onSwipeLeft: () -> Void = {  }
    var onSwipeRight: () -> Void = {  }

    @State private var called: Bool = false

    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onChanged({ value in
                    guard called == false else { return }
                    called = true
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
                })
                .onEnded { value in
                    called = false
            })
    }
}

extension View {
    func onSwipe(
        onSwipeUp: @escaping () -> Void = {  },
        onSwipeDown: @escaping () -> Void = {  },
        onSwipeLeft: @escaping () -> Void = {  },
        onSwipeRight: @escaping () -> Void = {  }
    ) -> some View {
        modifier(
            OnSwipeModifier(
                onSwipeUp: onSwipeUp,
                onSwipeDown: onSwipeDown,
                onSwipeLeft: onSwipeLeft,
                onSwipeRight: onSwipeRight
            )
        )
    }
}
