//
//  Date+.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import Foundation

extension Date {
    var relativeShort: String {
        let seconds = abs(timeIntervalSinceNow)
        let days = Int(seconds / 86_400)

        if days < 7 {
            return "\(max(days, 1))d ago"
        } else {
            return "\(days / 7)w ago"
        }
    }
}
