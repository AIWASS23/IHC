//
//  DashboardView.swift
//  IHC
//
//  Created by Marcelo De Araújo on 16/02/25.
//
//

import SwiftUI

struct DashboardView: View {

    @State private var showGovBrSheet = false
    @State private var verificationCode = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?

    let courses = [
        Course(image: "marcio", title: "Cabeleireiro", duration: "240h", days: "Seg, Qua, Sex", shift: "Tarde", workload: "6h", teacher: "Marcio"),
        Course(image: "juan", title: "Manicure", duration: "160h", days: "Ter, Qui", shift: "Manhã", workload: "4h", teacher: "Juan"),
        Course(image: "paulo", title: "Pedreiro", duration: "160h", days: "Ter, Qui", shift: "Tarde", workload: "2h", teacher: "Paulo"),
        Course(image: "pedro", title: "Pedreiro", duration: "240h", days: "Ter, Qua, Qui, Sex", shift: "Noite", workload: "8h", teacher: "Pedro")
    ]

    @State private var selectedCourse: Course?
    @State private var currentDate = Date()

    let weekdays = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"]

    let calendar: Calendar = {
        var cal = Calendar.current
        cal.firstWeekday = 1
        return cal
    }()

    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    var allDays: [Date?] {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let firstDay = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: currentDate),
            month: calendar.component(.month, from: currentDate),
            day: 1
        ))!

        let firstWeekday = calendar.component(.weekday, from: firstDay)

        var daysArray: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        daysArray += range.compactMap { day -> Date? in
            calendar.date(from: DateComponents(
                year: calendar.component(.year, from: currentDate),
                month: calendar.component(.month, from: currentDate),
                day: day
            ))
        }

        return daysArray
    }

    var activeDays: Set<Int> {
        guard let course = selectedCourse else { return [] }
        let diasPermitidos = Set(course.days.components(separatedBy: ", ").compactMap { diaSemanaEmNumero($0) })
        return Set(allDays.compactMap { $0 }
            .filter { diasPermitidos.contains(calendar.component(.weekday, from: $0)) }
            .map { calendar.component(.day, from: $0) })
    }

    var body: some View {
        VStack {
            TabView {
                ForEach(courses) { course in
                    HStack(spacing: 15) {
                        Image(course.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(AppColor.bordaCinza, lineWidth: 2))

                        VStack(alignment: .leading, spacing: 5) {

                            Text("\(course.title) - \(course.duration)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("\(course.days) - \(course.shift)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))

                            Text("\(course.workload) semanais")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))

                            Text("Professor: \(course.teacher)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .padding()
                    .background(selectedCourse?.id == course.id ? AppColor.azulPrimario : AppColor.verdeSucesso)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        selectedCourse = course
                    }
                }
            }
            .frame(height: 180)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height) * 0.9
                VStack {
                    VStack(spacing: 6) {

                        HStack {
                            Button(action: { changeMonth(by: -1) }) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(AppColor.verdeSucesso)
                                    .frame(width: 32, height: 32)
                            }
                            .clipShape(.circle)
                            .overlay(
                                Circle().stroke(AppColor.verdeSucesso))


                            Text(monthFormatter.string(from: currentDate))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(AppColor.verdeSucesso)

                            Button(action: { changeMonth(by: 1) }) {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(AppColor.verdeSucesso)
                                    .frame(width: 32, height: 32)
                            }
                            .clipShape(.circle)
                            .overlay(Circle().stroke(AppColor.verdeSucesso))
                        }
                        .padding(.top, 5)

                        Divider()

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                            ForEach(weekdays, id: \.self) { day in
                                Text(day)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColor.bordaCinza)
                            }
                        }
                        .padding(.bottom, 5)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {

                            ForEach(allDays, id: \.self) { day in
                                if let day = day {
                                    let dayNumber = calendar.component(.day, from: day)
                                    let isCourseDay = activeDays.contains(dayNumber)

                                    if isCourseDay, let selectedCourse = selectedCourse {
                                        NavigationLink(destination: TimeSlotsView(selectedDate: day, selectedCourse: selectedCourse)) {
                                            Text("\(dayNumber)")
                                                .frame(width: size / 10, height: size / 10)
                                                .background(AppColor.azulPrimario)
                                                .foregroundColor(isToday(day) ? AppColor.verdeSucesso : Color.white)
                                                .clipShape(.circle)
                                                .overlay(Circle().stroke(Color.blue))
                                        }
                                    } else {
                                        Text("\(dayNumber)")
                                            .frame(width: size / 10, height: size / 10)
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    Spacer().frame(width: size / 10, height: size / 10)
                                }
                            }
                        }

                    }
                    .padding()
                    .frame(width: size, height: size)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Button(action: {
                if let url = URL(string: "https://www.gov.br/pt-br") {
                    UIApplication.shared.open(url)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showGovBrSheet = true
                    }
                }
            }) {
                HStack {
                    Image(systemName: "studentdesk")
                    Text("Assinar Presença Mensal")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColor.azulPrimario)
                .foregroundStyle(AppColor.azulSuave)
                .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showGovBrSheet) {
                VStack(spacing: 20) {
                    Text("Digite o código de 6 números")
                        .font(.headline)
                        .foregroundStyle(AppColor.textoPadrao)

                    HStack(spacing: 10) {
                        ForEach(0..<6, id: \ .self) { index in
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

    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: Date())
    }

    private func diaSemanaEmNumero(_ dia: String) -> Int? {
        let dias = ["Dom": 1, "Seg": 2, "Ter": 3, "Qua": 4, "Qui": 5, "Sex": 6, "Sáb": 7]
        return dias[dia]
    }
}
