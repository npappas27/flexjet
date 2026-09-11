//
//  FlightsView.swift
//  flexjet
//
//  Created by Nick Pappas on 9/8/26.
//

import SwiftUI

import SwiftUI

struct FlightsView: View {
    @ObservedObject var viewModel: FlightsViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                header
                    .padding(.top, 8)
                picker
                    .padding(.top, 16)
                content
            }
            .padding(.horizontal, 24)
            .task {
                await viewModel.getFlights()
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text("Flights")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.primary)
            Spacer()
            Button {
                // action
            } label: {
                Image(systemName: "plus.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.brandPrimary)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            Spacer()
            AirplaneProgress()
            Spacer()

        case .loaded:
            ScrollView {
                switch viewModel.tabSelection {
                case .upcoming:
                    flightsList(viewModel.upcomingFlights)

                case .past:
                    flightsList(viewModel.pastFlights)
                }
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await viewModel.getFlights(refresh: true)
            }
            .padding(.top, 24)

        case .error:
            ContentUnavailableView {
                Label("Unable to Load Flights", systemImage: "exclamationmark.triangle")
            } actions: {
                Button("Retry") {
                    Task {
                        await viewModel.getFlights()
                    }
                }
            }
        }
    }

    private var picker: some View {
        Picker("Flight Status", selection: $viewModel.tabSelection) {
            Text("Upcoming")
                .tag(FlightsViewModel.TabSelection.upcoming)

            Text("Past")
                .tag(FlightsViewModel.TabSelection.past)
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private func flightsList(_ flights: [FlightResponse]) -> some View {
        if flights.isEmpty {
            ContentUnavailableView(
                "No Flights",
                systemImage: "airplane"
            )
            .padding(.top, 40)
        } else {
            LazyVStack(spacing: 12) {
                ForEach(flights) { flight in
                    if viewModel.tabSelection == .past {
                        NavigationLink {
                            FlightDetailsView(flight: flight)
                        } label: {
                            flightRow(flight)
                        }
                        .buttonStyle(.plain)
                    } else {
                        flightRow(flight)
                    }
                }
            }
        }
    }
    
    private func flightRow(_ flight: FlightResponse) -> some View {
        FlightRow(
            flight: flight,
            isUpcoming: viewModel.tabSelection == .upcoming,
            isCompleted: viewModel.completedFlightIDs.contains(flight.id)
        )
    }
}
#Preview {
    FlightsView(viewModel: .init())
}
