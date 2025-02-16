//
//  TimeSlotsView.swift
//  IHC
//
//  Created by Marcelo De Araújo on 16/02/25.
//

//import SwiftUI
//
//struct TimeSlotsView: View {
//    let selectedDate: Date
//    let selectedCourse: Course
//    let calendar = Calendar.current
//    let hourFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter
//    }()
//
//    var timeSlots: [Date] {
//        let (startHour, endHour) = shiftHours(for: selectedCourse.shift)
//        return (startHour..<endHour).compactMap { hour -> Date? in
//            return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate)
//        }
//    }
//
//    var body: some View {
//        List(timeSlots, id: \.self) { time in
//            Text(hourFormatter.string(from: time))
//                .font(.headline)
//                .padding()
//        }
//        .navigationTitle("Horários \(formattedDate())")
//    }
//
//    private func formattedDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        return formatter.string(from: selectedDate)
//    }
//
//    private func shiftHours(for shift: String) -> (Int, Int) {
//        switch shift {
//        case "Manhã":
//            return (8, 12)
//        case "Tarde":
//            return (13, 17)
//        case "Noite":
//            return (18, 22)
//        default:
//            return (0, 0)
//        }
//    }
//}

import SwiftUI

struct TimeSlotsView: View {
    let selectedDate: Date
    let selectedCourse: Course
    @State private var showGovBrSheet = false
    @State private var verificationCode = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    let calendar = Calendar.current
    let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var timeSlots: [Date] {
        let (startHour, endHour) = shiftHours(for: selectedCourse.shift)
        return (startHour..<endHour).compactMap { hour -> Date? in
            return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate)
        }
    }

    var randomSelectedSlots: [Date] {
        let shuffledSlots = timeSlots.shuffled()
        return Array(shuffledSlots.prefix(2))
    }

    var body: some View {
        List(timeSlots, id: \.self) { time in
            VStack {
                Text(hourFormatter.string(from: time))
                    .font(.headline)
                    .padding()

                // Verificar se o horário é um dos selecionados aleatoriamente
                if randomSelectedSlots.contains(time) {
                    Button(action: {
                        if let url = URL(string: "https://www.gov.br/pt-br") {
                            UIApplication.shared.open(url)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showGovBrSheet = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "person.badge.key.fill")
                            Text("Entrar com Gov.br")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColor.azulPrimario)
                        .foregroundStyle(AppColor.azulSuave)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showGovBrSheet) {
                        VStack(spacing: 20) {
                            Text("Digite o código de 6 números")
                                .font(.headline)
                                .foregroundStyle(AppColor.textoPadrao)
                            HStack(spacing: 10) {
                                ForEach(0..<6, id: \.self) { index in
                                    TextField("", text: $verificationCode[index])
                                        .frame(width: 40, height: 50)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .focused($focusedField, equals: index)
                                        .onChange(of: verificationCode[index]) { _, newValue in
                                            if newValue.count == 1 {
                                                focusedField = (index < 5) ? index + 1 : nil
                                            }
                                        }
                                }
                            }
                            Button("Confirmar") {
                                showGovBrSheet = false
                            }
                            .padding()
                            .background(AppColor.verdeSucesso)
                            .foregroundColor(AppColor.azulSuave)
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .navigationTitle("Horários \(formattedDate())")
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: selectedDate)
    }

    private func shiftHours(for shift: String) -> (Int, Int) {
        switch shift {
        case "Manhã":
            return (8, 12)
        case "Tarde":
            return (13, 17)
        case "Noite":
            return (18, 22)
        default:
            return (0, 0)
        }
    }
}


