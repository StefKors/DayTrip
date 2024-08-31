//
//  TopBarButtons.swift
//  DayTrip
//
//  Created by Stef Kors on 22/08/2024.
//

import SwiftUI

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
