//
//  NameView.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI

struct NameView: View {
    let route: Route

    @State private var asyncName: String = "...loading"

    private var name: String {
        route.points.first?.name ?? asyncName
    }

    var body: some View {
        Text(name)
            .task {
                guard route.points.first?.name == nil else { return }
                if let name = try? await route.name() {
                    self.asyncName = name
                } else {
                    self.asyncName = "failed"
                }
            }
    }
}

#Preview {
    NameView(route: .preview)
}
