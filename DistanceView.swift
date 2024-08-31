//
//  DistanceView.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI
import CoreLocation

struct DistanceView: View {
    let distance: CLLocationDistance?
    var body: some View {
        if let distance {
            Text(
                Measurement(
                    value: distance,
                    unit: UnitLength.meters
                ),
                format: formatStyle
            )
            .contentTransition(.numericText())
        }
    }

    private let formatStyle = Measurement<UnitLength>.FormatStyle(
        width: .abbreviated,
        numberFormatStyle: .localizedDouble(locale: .current)
    )
}

#Preview {
    DistanceView(distance: 40)
}
