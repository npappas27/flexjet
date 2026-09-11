//
//  CompletedFlightsStore.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import Combine
import Foundation

final class CompletedFlightsStore: ObservableObject {
    @Published private(set) var completedIDs: Set<String> = []

    private let key = "completed_flights"

    init() {
        completedIDs = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    func isCompleted(_ id: String) -> Bool {
        completedIDs.contains(id)
    }

    func complete(_ id: String) {
        completedIDs.insert(id)
        UserDefaults.standard.set(Array(completedIDs), forKey: key)
    }
}
