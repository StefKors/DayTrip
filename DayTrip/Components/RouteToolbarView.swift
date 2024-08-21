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

struct RecordingTools: View {
    @EnvironmentObject var manager: LocationManager
    
    var body: some View {
        HStack {
            StatusIndicator()
            
            Spacer()
            
            if (manager.status == .paused || manager.status == .ready) {
                PlayButton()
                    .transition(.slide.combined(with: .blurReplace))
            }
            
            if (manager.status == .recording) {
                PauseButton()
                    .transition(.slide.combined(with: .blurReplace))
            }
            
            if (manager.status == .paused) {
                StopButton()
                    .transition(.slide.combined(with: .blurReplace))
            }
            
            if (manager.status == .stopped) {
                SaveButton()
                    .transition(.slide.combined(with: .blurReplace))
            }
        }
    }
}

#Preview {
    RecordingTools()
        .environmentObject(LocationManager())
}

struct RouteToolbarView: View {
    @EnvironmentObject var manager: LocationManager
    
    
    var state: ToolbarViewState = .mini
    
    
    var body: some View {
        VStack {
            RecordingTools()
            
            RouteListView()
            
            
            //                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            //                .fixedSize(horizontal: false, vertical: true)
            //                .transition(.move(edge: .bottom).combined(with: .opacity))
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

struct NameView: View {
    let route: Route
    
    @State var name: String = "...loading"
    var body: some View {
        Text(name)
            .task {
                if let name = try? await route.name() {
                    self.name = name
                } else {
                    self.name = "failed"
                }
            }
    }
}




struct RouteListView: View {
    //    @Query(sort: \.timestamp, order: .reverse) var routes: [Route]
    @Query private var routes: [Route]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                List(routes) { route in
                    HStack {
                        NameView(route: route)
                        Text(
                            Measurement(
                                value: route.distance,
                                unit: UnitLength.meters
                            ),
                            format: formatStyle
                        )
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        
    }
    
    private let formatStyle = Measurement<UnitLength>.FormatStyle(
        width: .abbreviated,
        numberFormatStyle: .localizedDouble(locale: .current)
    )
}

#Preview {
    RouteListView()
        .modelContainer(DataController.previewContainer)
}
