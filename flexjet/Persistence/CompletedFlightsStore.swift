//
//  CompletedFlightsStore.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import Foundation

enum CompletedFlightsStore {
    private static let key = "completedFlightIDs"

    static var ids: Set<String> {
        get {
            Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: key)
        }
    }

    static func isCompleted(_ id: String) -> Bool {
        ids.contains(id)
    }

    static func complete(_ id: String) {
        var current = ids
        current.insert(id)
        ids = current
    }
}
