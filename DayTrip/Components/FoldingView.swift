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


struct FoldingView: View {
    @EnvironmentObject var manager: LocationManager

    @State private var showToolbar: Bool = false

    @State private var toolbarState: ToolbarViewState = .mini

    @Namespace private var animation

    var height: CGFloat {
        switch toolbarState {
        case .mini:
            return 100
        case .medium:
            return 200
        case .full:
            return 600
        }
    }

    var otherHeight: CGFloat {
        switch toolbarState {
        case .mini:
            return 0
        case .medium:
            return 200
        case .full:
            return 600
        }
    }

    var body: some View {
        MapRouteView()
            .floatingSheet(onSwipeUp: { newDetent in
                if newDetent.height >= FloatingSheetDetent.medium.height {
                    toolbarState = toolbarState.next()
                }
            }, onSwipeDown: { newDetent in
                //                if newDetent.height < FloatingSheetDetent.medium.height {
                //
                //                }
                toolbarState = toolbarState.previous()
            }, sheetContent: {
                VStack {
                    if showToolbar {
                        VStack {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    RecordingTools()

                                    RouteListView()
                                    if toolbarState != .mini {

//                                            .transition(.opacity.combined(with: .move(edge: .bottom)))
//                                        VStack {
//                                                                                        .frame(height: otherHeight)
//                                                                                        .clipped()
//                                        }
                                        //                                    .transition(.iris)
                                    }
                                }
                            }
                        }
                        .animation(.snappy, value: manager.status)
                    }
                }
            })

        //            .padding(100)

        //            .overlay(alignment: .bottom) {
        //                VStack {
        //                    if showToolbar {
        //                        VStack {
        //                            VStack(alignment: .leading) {
        //                                VStack(alignment: .leading, spacing: 0) {
        //                                    RecordingTools()
        ////                                    if toolbarState == .mini {
        ////                                        RecordingTools()
        ////                                            .matchedGeometryEffect(id: "record-tools", in: animation)
        ////                                    } else {
        ////                                            RecordingTools()
        ////                                                .matchedGeometryEffect(id: "record-tools", in: animation)
        ////
        ////
        //////                                                .transition(.move(edge: .bottom))
        ////                                    }
        //
        //                                    VStack {
        //                                        RouteListView()
        //                                            .frame(height: otherHeight)
        //                                            .clipped()
        //                                    }
        //                                    .transition(.iris)
        //                                }
        //                            }
        //
        //
        //
        //                            //                .clipShape(RoundedRectangle(cornerRadius: 10))
        //
        //                            //
        //                            //                .transition(.move(edge: .bottom).combined(with: .opacity))
        //                        }
        //                        .clipped()
        //                        .animation(.snappy, value: toolbarState)
        //                        .padding(.leading, 8)
        //                        .padding(.vertical, 6)
        //                        .padding(.trailing, 6)
        //                        .background {
        //                            RoundedRectangle(cornerRadius: 24, style: .continuous)
        //                                .fill(.ultraThickMaterial)
        //                        }
        //                        .shadow(radius: 25)
        //                        .safeAreaPadding(.horizontal)
        //                        .animation(.snappy, value: manager.status)
        //
        ////                            .animation(.bouncy, value: toolbarState)
        ////                            .transition(
        ////                                .asymmetric(
        ////                                    insertion: .scale(scale: 0.7).combined(with: .offset(y: 100).combined(with: .opacity)),
        ////                                    removal: .scale(scale: 0.7).combined(with: .offset(y: 100).combined(with: .opacity))
        ////                                )
        ////                            )
        //                    }
        //                }
        ////                .sheet(isPresented: .constant(true), content: {
        ////                    VStack(alignment: .leading, spacing: 0) {
        ////                        RecordingTools()
        ////
        ////                        VStack {
        ////                            RouteListView()
        ////                                .frame(height: otherHeight)
        ////                                .clipped()
        ////                        }
        ////                        .transition(.iris)
        ////                    }
        ////                    .presentationDetents([.height(100), .height(200), .height(400), .height(600)])
        ////                })
        ////                .frame(maxHeight: height)
        //
        ////                .OnSwipeWithRubberBanding(onSwipeUp: {
        ////                    print("swipe up")
        ////                    withAnimation(.bouncy) {
        ////                        toolbarState = toolbarState.next()
        ////                    }
        ////                }, onSwipeDown: {
        ////                    withAnimation(.bouncy) {
        ////                        toolbarState = toolbarState.previous()
        ////                    }
        ////                })
        //
        //            }
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
        .modelContainer(DataController.previewContainer)
}
