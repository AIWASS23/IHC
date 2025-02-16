//
//  DashboardView 2.swift
//  IHC
//
//  Created by Marcelo De Araújo on 16/02/25.
//


import SwiftUI

struct DashboardView: View {

    let courses = [
        Course(image: "marcio", title: "Cabeleireiro", duration: "240h", days: "Seg, Qua, Sex - Tarde", workload: "6h", teacher: "Marcio"),
        Course(image: "juan", title: "Manicure", duration: "160h", days: "Ter, Qui - Manhã", workload: "6h", teacher: "Juan"),
        Course(image: "paulo", title: "Pedreiro", duration: "160h", days: "Ter, Qui - Tarde", workload: "6h", teacher: "Paulo"),
        Course(image: "pedro",title: "Pedreiro", duration: "240h", days: "Ter, Qui, Sex - Noite", workload: "6h", teacher: "Pedro")
    ]

    @State private var currentDate = Date()
    let calendar = Calendar.current
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    var days: [Date] {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return range.compactMap { day -> Date? in
            return calendar.date(
                from: DateComponents(
                    year: calendar.component(.year, from: currentDate),
                    month: calendar.component(.month, from: currentDate),
                    day: day)
            )
        }
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
                                .overlay(Circle().stroke(AppColor.bordaCinza, lineWidth: 2))

                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(course.title) - \(course.duration)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Text(course.days)
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
                        .background(AppColor.verdeSucesso)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                    }
                }
                .frame(height: 180)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            }

        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.9
            VStack {
                VStack(spacing: 6) {
                    HStack {
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.green)
                        }
                        .clipShape(.circle)
                        .overlay(Circle().stroke(Color.green))

                        Text(monthFormatter.string(from: currentDate))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)

                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.green)
                        }
                        .clipShape(.circle)
                        .overlay(Circle().stroke(Color.green))
                    }
                    .padding(.top)

                    Divider()

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(days, id: \.self) { day in
                            NavigationLink(destination: TimeSlotsView(selectedDate: day)) {
                                Text("\(calendar.component(.day, from: day))")
                                    .frame(width: size / 10, height: size / 10)
                                    .background(isToday(day) ? Color.blue : Color.green.opacity(0.1))
                                    .foregroundColor(Color.blue)
                                    .clipShape(.circle)
                                    .overlay(Circle().stroke(Color.green))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .frame(width: size, height: size)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 5))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}
