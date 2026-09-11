//
//  ProfileView.swift
//  flexjet
//
//  Created by Nick Pappas on 9/9/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        FlexButton(title: "Log out") {
            viewModel.logout()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    ProfileView()
}
