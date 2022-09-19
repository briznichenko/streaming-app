//
//  EventsDataSource.swift
//  StreamingApp
//
//  Created by Andriy Briznichenko on 7/9/22.
//

import Foundation

// MARK: - Stub

final class EventsDataSource {
    private var events = ["1", "2", "3"]
    
    var eventsCount: Int {
        return events.count
    }
    
    func eventAt(index: Int) -> Any? {
        guard events.endIndex >= index, index >= events.startIndex else { return nil }
        return events[index]
    }
}
