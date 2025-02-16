//
//  TimeSlotsView.swift
//  IHC
//
//  Created by Marcelo De Araújo on 16/02/25.
//

import SwiftUI

struct TimeSlotsView: View {
    let selectedDate: Date
    let calendar = Calendar.current
    let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var timeSlots: [Date] {
        let startHour = 8
        let endHour = 18
        return (startHour..<endHour).compactMap { hour -> Date? in
            return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate)
        }
    }

    var body: some View {
        List(timeSlots, id: \.self) { time in
            Text(hourFormatter.string(from: time))
                .font(.headline)
                .padding()
        }
        .navigationTitle("Horários \(formattedDate())")
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: selectedDate)
    }
}
