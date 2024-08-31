//
//  RouteToolbarView.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

enum ToolbarViewState: String {
    case mini
    case medium
    case full

    func next() -> ToolbarViewState {
        switch self {
        case .mini:
            return .medium
        case .medium:
            return .full
        case .full:
            return .full
        }
    }

    func previous() -> ToolbarViewState {
        switch self {
        case .mini:
            return .mini
        case .medium:
            return .mini
        case .full:
            return .medium
        }
    }
}

struct RouteToolbarView: View {
    @EnvironmentObject var manager: LocationManager

    var state: ToolbarViewState = .mini

    var body: some View {
        VStack {
            RecordingTools()

            RouteListView()
        }
        .animation(.snappy, value: state)
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
    }
}

#Preview {
    VStack {
        RouteToolbarView(state: .mini)
        RouteToolbarView(state: .medium)
        RouteToolbarView(state: .full)
    }
    .environmentObject(LocationManager())
}
