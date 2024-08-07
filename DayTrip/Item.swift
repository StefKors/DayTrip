//
//  Item.swift
//  DayTrip
//
//  Created by Stef Kors on 07/08/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
