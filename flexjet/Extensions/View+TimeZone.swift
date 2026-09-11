//
//  View+TimeZone.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import SwiftUI

/// Rebuilds the view when the system time zone changes.
///
/// `Date.formatted()` resolves against `TimeZone.current` at render time and
/// bakes the result into a `String`. SwiftUI has no dependency on the system
/// time zone, so a zone change while the app is running leaves already-rendered
/// times showing the old zone. Changing the subtree's identity forces a rebuild.
private struct TimeZoneAware: ViewModifier {
    @State private var token = UUID()

    func body(content: Content) -> some View {
        content
            .id(token)
            .onReceive(
                NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)
            ) { _ in
                token = UUID()
            }
    }
}

extension View {
    /// Re-renders this view in the user's new time zone when the system zone changes.
    func timeZoneAware() -> some View {
        modifier(TimeZoneAware())
    }
}
