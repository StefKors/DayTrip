//
//  SaveButton.swift
//  DayTrip
//
//  Created by Stef Kors on 20/08/2024.
//


import SwiftUI
import SwiftData
import MapKit

struct SaveButton: View {
    @EnvironmentObject var manager: LocationManager
    @Environment(\.modelContext) var modelContext

    var body: some View {
        Button("Save") {
            do {
                let route = Route(points: manager.points.map{ $0.toSimpleCoordinate()})
                modelContext.insert(route)
                try modelContext.save()
                manager.status = .ready
            } catch {
                print(error.localizedDescription)
            }
        }
        .labelStyle(.titleOnly)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.foreground.quinary)
        }
    }
}

#Preview {
    SaveButton()
        .environmentObject(LocationManager())
}
