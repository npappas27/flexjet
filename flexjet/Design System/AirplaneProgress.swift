//
//  AirplaneProgress.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import SwiftUI

struct AirplaneProgress: View {
    var body: some View {
        Image(systemName: "airplane")
            .font(.system(size: 32, weight: .semibold))
            .foregroundStyle(.brandPrimary)
            .symbolEffect(.pulse, options: .repeating)
    }
}

#Preview {
    AirplaneProgress()
}
