//
//  FlightDetailsView.swift
//  flexjet
//
//  Created by Nick Pappas on 9/11/26.
//

import SwiftUI

struct FlightDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isCompleted = false
    
    let flight: FlightResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .zero) {
                header
                routeCards
                    .padding(.top, 24)
                details
                    .padding(.top, 16)
                completeButton
                    .padding(.top, 16)
            }
            .padding(.horizontal, 24)
            .onAppear {
                isCompleted = CompletedFlightsStore.isCompleted(flight.id)
            }
        }
        .background(Color(.systemBackground))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(flight.originIata) to \(flight.destinationIata)")
                .font(.title2)
                .fontWeight(.bold)
        }
    }

    private var routeCards: some View {
        HStack(spacing: 12) {
            routeCard(
                city: flight.origin,
                label: "Origin"
            )

            routeCard(
                city: flight.destination,
                label: "Destination"
            )
        }
    }

    private func routeCard(
        city: String,
        label: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(city)
                .font(.footnote)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4).opacity(0.4), lineWidth: 1)
        }
    }

    private var details: some View {
        VStack(spacing: 16) {
            detailRow(
                title: "Departure Date",
                value: "\(flight.departure.formatted(.dateTime.month(.abbreviated).day())) (\(flight.departure.relativeShort))"
            )

            detailRow(
                title: "Trip Number",
                value: flight.tripNumber
            )

            detailRow(
                title: "Flight Number",
                value: flight.flightNumber ?? "—"
            )

            detailRow(
                title: "Tail Number",
                value: flight.tailNumber
            )

            detailRow(
                title: "Price",
                value: flight.price.formatted(.currency(code: "USD"))
            )
        }
    }

    private func detailRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }

    private var completeButton: some View {
        Button {
            guard !isCompleted else { return }
            CompletedFlightsStore.complete(flight.id)
            isCompleted = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                Text(isCompleted ? "Completed" : "Complete")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(isCompleted ? .white : .primary)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isCompleted ? Color.brandPrimary : Color.clear)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        isCompleted ? Color.clear : Color(.separator),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FlightDetailsView(
        flight: FlightResponse(
            id: "1",
            tripNumber: "1234567",
            flightNumber: "UA890",
            tailNumber: "N987UA",
            origin: "Las Vegas",
            originIata: "LAS",
            destination: "New York",
            destinationIata: "JFK",
            departure: Date(),
            arrival: Date().addingTimeInterval(60 * 60 * 5),
            price: 349
        )
    )
}
