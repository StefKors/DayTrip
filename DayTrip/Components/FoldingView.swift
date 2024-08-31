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
                toolbarState = toolbarState.next()
            }, onSwipeDown: { newDetent in
                toolbarState = toolbarState.previous()
            }, sheetContent: {
                        VStack {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    RecordingTools()

                                    RouteListView()
                                }
                            }
                        }
                        .animation(.snappy, value: manager.status)
            })
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
