//
//  FoldingView.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//
//  https://developer.apple.com/documentation/mapkit/mapkit_for_appkit_and_uikit/mapkit_overlays/displaying_an_updating_path_of_a_user_s_location_history


import SwiftUI
import SwiftData
import MapKit

struct TopBarButtons: View {
    var body: some View {
        HStack {
            Button("test") {

            }
        }
        .padding(.leading, 8)
        .padding(.vertical, 6)
        .padding(.trailing, 6)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThickMaterial)
        }
        .shadow(radius: 25)
        .safeAreaPadding(.top)
        .safeAreaPadding(.leading)
        .ignoresSafeArea(.all, edges: .top)
    }
}

#Preview {
    TopBarButtons()
}

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



struct FoldingView: View {
    @EnvironmentObject var manager: LocationManager

    @State private var showToolbar: Bool = false

    @State private var toolbarState: ToolbarViewState = .mini

    var height: CGFloat {
        switch toolbarState {
        case .mini:
            return 20
            case .medium:
            return 200
        case .full:
            return 600
        }
    }

    var body: some View {
        MapRouteView()

//            .padding(100)

            .overlay(alignment: .bottom) {
                VStack {
                    if showToolbar {
                        VStack {
                            
                            RecordingTools()

                            if toolbarState != .mini {

                                RouteListView()
                                    .transition(.move(edge: .bottom))
                            }


                            //                .clipShape(RoundedRectangle(cornerRadius: 10))

                            //
                            //                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        .clipped()
                        .animation(.snappy, value: toolbarState)
                        .padding(.leading, 8)
                        .padding(.vertical, 6)
                        .padding(.trailing, 6)
                        .background {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThickMaterial)
                        }
                        .shadow(radius: 25)
                        .safeAreaPadding(.horizontal)
                        .animation(.snappy, value: manager.status)

//                            .animation(.bouncy, value: toolbarState)
//                            .transition(
//                                .asymmetric(
//                                    insertion: .scale(scale: 0.7).combined(with: .offset(y: 100).combined(with: .opacity)),
//                                    removal: .scale(scale: 0.7).combined(with: .offset(y: 100).combined(with: .opacity))
//                                )
//                            )
                    }
                }
                .frame(maxHeight: height)
                .onSwipe(onSwipeUp: {
                    print("swipe up")
                    withAnimation(.bouncy) {
                        toolbarState = toolbarState.next()
                    }
                }, onSwipeDown: {
                    withAnimation(.bouncy) {
                        toolbarState = toolbarState.previous()
                    }
                })
            }
            .onAppear {
                withAnimation(.smooth.delay(0.5)) {
                    showToolbar = true
                }
            }
    }
}

#Preview {
    FoldingView()
        .environmentObject(LocationManager())
}
