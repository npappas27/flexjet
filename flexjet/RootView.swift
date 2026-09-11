//
//  ContentView.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import Combine
import FactoryKit
import SwiftUI

final class RootViewModel: ObservableObject {
    @Injected(\.authRepository) private var authRepository
    @Published var authed: Bool = false
    
    init() {
        setupSubs()
    }
    
    private func setupSubs() {
        authRepository.$token
            .map { $0 != nil }
            .assign(to: &$authed)
    }
}

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    var body: some View {
        if !viewModel.authed {
            LoginView()
        } else {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @StateObject private var flightsViewModel = FlightsViewModel()

    var body: some View {
        TabView {
            FlightsView(viewModel: flightsViewModel)
                .tabItem { Label("Flights", systemImage: "airplane") }

            Text("Favorites")
                .tabItem { Label("Favorites", systemImage: "heart") }

            Text("Contracts")
                .tabItem { Label("Contracts", systemImage: "signature") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .tint(.brandPrimary)
    }
}

#Preview {
    RootView()
}
