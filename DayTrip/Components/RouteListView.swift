//
//  RouteListView.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI
import SwiftData

struct RouteListView: View {

    @Query private var routes: [Route]

    var body: some View {
//        ScrollView {
            VStack {
                ForEach(routes) { route in
//                    Divider()
                    HStack {
                        NameView(route: route)
                        Spacer()
                        DistanceView(distance: route.distance)
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.clear)
            }
            .padding(.horizontal)
//        }
    }
}

#Preview {
    RouteListView()
        .modelContainer(DataController.previewContainer)
}
