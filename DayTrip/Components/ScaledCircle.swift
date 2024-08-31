//
//  ScaledRectangle.swift
//  DayTrip
//
//  Created by Stef Kors on 21/08/2024.
//

import SwiftUI

struct ScaledRectangle: Shape {
    // This controls the size of the circle inside the
    // drawing rectangle. When it's 0 the circle is
    // invisible, and when it’s 1 the circle fills
    // the rectangle.
    var animatableData: Double

    func path(in rect: CGRect) -> Path {
        let newRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * animatableData)

        return Rectangle().path(in: newRect)
    }
}

// A general modifier that can clip any view using a any shape.
struct ClipShapeModifier<T: Shape>: ViewModifier {
    let shape: T

    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}

// A custom transition combining ScaledRectangle and ClipShapeModifier.
extension AnyTransition {
    static var iris: AnyTransition {
        .modifier(
            active: ClipShapeModifier(shape: ScaledRectangle(animatableData: 0)),
            identity: ClipShapeModifier(shape: ScaledRectangle(animatableData: 1))
        )
    }
}

struct TestView: View {
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Color.blue
                .frame(width: 200, height: 200)

            if isShowingRed {
                Color.red
                    .frame(width: 200, height: 200)
                    .transition(.iris)
                    .zIndex(1)
            }
        }
        .padding(50)
        .onTapGesture {
            withAnimation(.spring) {
                isShowingRed.toggle()
            }
        }
    }
}

#Preview {
    TestView()
}
