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

enum FloatingSheetDetent: Codable, Equatable, Comparable {
    case height(CGFloat)
    case medium
    case large

    var height: CGFloat {
        if case .height(let h) = self {
            return h
        } else if case .medium = self {
            return 400 // TODO: calc half view height
        } else if case .large = self {
            return 600 // TODO: calc full view height
        } else {
            return 400
        }
    }
}



struct FloatingSheetModifier<SheetContent: View>: ViewModifier {
    var onSwipeUp: (_ detent: FloatingSheetDetent) -> Void = { _ in }
    var onSwipeDown: (_ detent: FloatingSheetDetent) -> Void = { _ in }
    var onSwipeLeft: (_ detent: FloatingSheetDetent) -> Void = { _ in }
    var onSwipeRight: (_ detent: FloatingSheetDetent) -> Void = { _ in }

    var horizontalEnabled = false
    var verticalEnabled = true

    var detents: [FloatingSheetDetent]   = [.height(50), .medium, .large]
    @State private var currentDetent: FloatingSheetDetent = .height(50)

    @ViewBuilder var sheetContent: () -> SheetContent

//    @State private var yTranslation: CGFloat = .zero
//    @State private var yScaling: CGFloat = 1

//    @State private var xTranslation: CGFloat = .zero
//    @State private var xScaling: CGFloat = 1

    @State private var dragLimit: CGFloat = 10

    @State private var dragOffset: CGFloat = 0

    var computedHeight: CGFloat {
        let height = currentDetent.height + dragOffset
        print("\(height.description) dragOffset: \(dragOffset.description) | current: \(currentDetent.height.description)")
        return  height.clamped(lower: 35, upper: height)
    }

    func body(content: Content) -> some View {
        content

            .overlay(
                alignment: .bottom,
                content: {
                    sheetContent()
                        .safeAreaPadding(.horizontal, 6)
                        .safeAreaPadding(.top, 5)
                        .frame(maxHeight: computedHeight, alignment: .top)
                        .clipShape(ScaledRectangle(animatableData: 1))
                        .background {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThickMaterial)
                                .stroke(.foreground.quinary, lineWidth: 1)
                        }
                        .shadow(radius: 25)
                        .safeAreaPadding(.horizontal)
                        .overlay(alignment: .top) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThickMaterial.secondary)
                                .stroke(.foreground.quinary, lineWidth: 1)
                                .shadow(radius: 25)
                                .frame(width: 200, height: 6)
                                .padding(.bottom, 4)
                                .offset(y: -3)
                                .allowsHitTesting(false)
                        }
//                        .offset(x: xTranslation, y: yTranslation)
                        .gesture(
                            DragGesture(minimumDistance: 20, coordinateSpace: .global)
                                .onChanged { value in
                                    dragOffset = value.translation.height * -1
//                                    handleRubberBanding(value)
                                }
                                .onEnded { value in
                                    setNewDetent(value)
//                                    withAnimation(.spring()) {
//                                        yTranslation = .zero
//                                        xTranslation = .zero
////                                        yScaling = 1
////                                        xScaling = 1
//                                    }
                                }
                        )
                        .animation(.smooth, value: computedHeight)
                })

            .task(id: detents) {
                if let detent = detents.first {
                    self.currentDetent = detent
                }
            }
    }

//    func handleRubberBanding(_ value: DragGesture.Value) {
//        if verticalEnabled {
//            let velocityBanding = ((value.velocity.height/10000) * -1).clamped(lower: -0.12, upper: 0.12)
//            if value.translation.height >= dragLimit {
//                // hits limit
//                yTranslation = dragLimit * (1.00 + log10(value.translation.height / dragLimit))
////                withAnimation(.spring(blendDuration: 300)) {
////                    yScaling = 1 + velocityBanding
////                }
//            } else if value.translation.height <= (dragLimit * -1) {
//                // below limit
//                yTranslation = (dragLimit * -1) * (1.00 + log10(value.translation.height / (dragLimit * -1)))
////                withAnimation(.spring(blendDuration: 300)) {
////                    yScaling = 1 + velocityBanding
////                }
//            } else {
//                // limiter
//                yTranslation = value.translation.height
//            }
//        }
//
//        if horizontalEnabled {
//            let velocityBanding = ((value.velocity.width/10000) * -1).clamped(lower: -0.12, upper: 0.12)
//            if value.translation.width >= dragLimit {
//                xTranslation = dragLimit * (1.00 + log10(value.translation.width / dragLimit))
////                withAnimation(.spring(blendDuration: 300)) {
////                    xScaling = 1 + velocityBanding
////                }
//            } else if value.translation.width <= (dragLimit * -1) {
//                xTranslation = (dragLimit * -1) * (1.00 + log10(value.translation.width / (dragLimit * -1)))
////                withAnimation(.spring(blendDuration: 300)) {
////                    xScaling = 1 + velocityBanding
////                }
//            } else {
//                xTranslation = value.translation.width
//            }
//        }
//    }

    func handleCallback(_ value: DragGesture.Value, _ newDetent: FloatingSheetDetent) {
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height

        if abs(horizontalAmount) > abs(verticalAmount) {
            if horizontalAmount < 0 {
                onSwipeLeft(newDetent)
            } else {
                onSwipeRight(newDetent)
            }
        } else {
            if verticalAmount < 0 {
                onSwipeUp(newDetent)
            } else {
                onSwipeDown(newDetent)
            }
        }
    }

    func setNewDetent(_ value: DragGesture.Value) {
        let expectedHeight = currentDetent.height + (value.predictedEndTranslation.height * -1)
        var smallest: CGFloat? = nil
        var indexOfSmallest: Int = 0

        for (index, detent) in detents.enumerated() {

            let delta = abs(expectedHeight - detent.height)
            if smallest == nil || delta < smallest! {
                smallest = delta
                indexOfSmallest = index
            }
        }

        let newDetent = detents[indexOfSmallest]

//        withAnimation(.spring(blendDuration: 300)) {
            print("handleCallback")
            if (currentDetent.height != newDetent.height) {
                print("handleCallback")
                handleCallback(value, newDetent)
            }
            currentDetent = newDetent
            dragOffset = 0

//        }

    }
}

extension View {
    func floatingSheet<SheetContent: View>(
        onSwipeUp: @escaping (_ detent: FloatingSheetDetent) -> Void = { _ in },
        onSwipeDown: @escaping (_ detent: FloatingSheetDetent) -> Void = { _ in },
        onSwipeLeft: @escaping (_ detent: FloatingSheetDetent) -> Void = { _ in },
        onSwipeRight: @escaping (_ detent: FloatingSheetDetent) -> Void = { _ in },
        horizontalEnabled: Bool = false,
        verticalEnabled: Bool = true,
        @ViewBuilder sheetContent: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            FloatingSheetModifier(
                onSwipeUp: onSwipeUp,
                onSwipeDown: onSwipeDown,
                onSwipeLeft: onSwipeLeft,
                onSwipeRight: onSwipeRight,
                horizontalEnabled: horizontalEnabled,
                verticalEnabled: verticalEnabled,
                sheetContent: sheetContent
            )
        )
    }
}

#Preview {
    VStack {
        RoundedRectangle(cornerRadius: 8)
            .fill(.accent.quinary)
        RoundedRectangle(cornerRadius: 8)
            .fill(.accent.quinary)
        RoundedRectangle(cornerRadius: 8)
            .fill(.accent.quinary)
        RoundedRectangle(cornerRadius: 8)
            .fill(.accent.quinary)
    }
    .scenePadding()
    .floatingSheet() {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.orange)
                .frame(height: 80)
            RoundedRectangle(cornerRadius: 8)
                .fill(.orange)
                .frame(height: 80)
            RoundedRectangle(cornerRadius: 8)
                .fill(.orange)
                .frame(height: 80)
            RoundedRectangle(cornerRadius: 8)
                .fill(.orange)
                .frame(height: 80)
        }
    }
}
