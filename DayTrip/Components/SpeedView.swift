//
//  SpeedView.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI
import CoreLocation

struct SpeedView: View {
    let speed: CLLocationSpeed?
    var body: some View {
        if let speed {
            Text(
                Measurement(
                    value: speed,
                    unit: UnitSpeed.kilometersPerHour
                ),
                format: formatStyle
            )
            .contentTransition(.numericText())
        }
    }

    private let formatStyle = Measurement<UnitSpeed>.FormatStyle(
        width: .abbreviated,
        numberFormatStyle: .localizedDouble(locale: .current)
    )
}

#Preview {
    SpeedView(speed: 3.8)
}
