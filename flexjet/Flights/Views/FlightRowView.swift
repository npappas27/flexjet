//
//  FlightRowView.swift
//  flexjet
//
//  Created by Nick Pappas on 9/10/26.
//

import SwiftUI

struct FlightRow: View {
    let flight: FlightResponse
    let isUpcoming: Bool
    let isCompleted: Bool

    private var isFlightToday: Bool {
        isUpcoming &&
        Calendar.current.isDateInToday(flight.departure) &&
        flight.departure > Date()
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    calendar

                    VStack(alignment: .leading, spacing: 8) {
                        originToDesintation
                        flightTimeOrNumber
                    }
                }
                if isFlightToday {
                    flightTodayCapsule
                }
            }

            Spacer()

            if !isUpcoming {
                completedCheckmark
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(.systemGray4), lineWidth: 1)
        }
    }
    
    private var calendar: some View {
        VStack(spacing: 0) {
            Text(flight.departure.formatted(.dateTime.month(.abbreviated)))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(isUpcoming ? .red : .secondary)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 3)
                .background(
                    isUpcoming
                        ? Color.red.opacity(0.12)
                        : Color(.systemGray5)
                )

            Text(flight.departure.formatted(.dateTime.day()))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .frame(width: 62)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    private var originToDesintation: some View {
        Text("\(airportName(flight.origin, iata: flight.originIata)) to \(airportName(flight.destination, iata: flight.destinationIata))")
            .font(.subheadline)
            .bold()
            .lineLimit(1)
    }
    
    @ViewBuilder
    private var flightTimeOrNumber: some View {
        if isUpcoming {
            Text(
                "\(flight.departure.formatted(date: .omitted, time: .shortened)) - \(flight.arrival.formatted(date: .omitted, time: .shortened))"
            )
            .font(.body)
            .foregroundStyle(.secondary)
        } else if let flightNumber = flight.flightNumber {
            Text(flightNumber)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
    
    private var flightTodayCapsule: some View {
        Label("Flight Today", systemImage: "calendar")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.brandPrimary)
            .clipShape(Capsule())
    }
    
    private var completedCheckmark: some View {
        Image(systemName: isCompleted ? "checkmark.seal.fill" : "checkmark.seal")
            .font(.system(size: 28))
            .foregroundStyle(isCompleted ? .brandPrimary : .black)
    }
    
    private func airportName(_ name: String, iata: String) -> String {
        name
            .replacingOccurrences(of: "(\(iata))", with: "")
            .replacingOccurrences(of: iata, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    FlightRow(
        flight: .init(
            id: "",
            tripNumber: "123",
            flightNumber: "UA1223",
            tailNumber: "BCDEF",
            origin: "Cleveland",
            originIata: "231",
            destination: "Dallas",
            destinationIata: "",
            departure: Date(),
            arrival: Date(),
            price: 44
        ), isUpcoming: true, isCompleted: false
    )
        .padding(.horizontal, 8)
}
