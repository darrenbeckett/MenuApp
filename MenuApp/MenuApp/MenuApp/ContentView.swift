import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var startDate: Date = Date().startOfWeek
    @State private var endDate: Date = Date().endOfWeek
    
    var body: some View {
        VStack(spacing: 0) {
            WeekHeaderView(startDate: $startDate, endDate: $endDate)
                .background(Color.white) // Optional: background color

            // Display rows for each day of the week
            ScrollView(showsIndicators: false) { // Optionally hide scroll indicators
                VStack(spacing: 0) { // Set spacing to 0
                    ForEach(daysOfWeek, id: \.date) { day in
                        DayRowView(dayOfWeek: day.dayOfWeek, date: day.date)
                            .padding(0) // Ensure no padding added here
                    }
                }
                .padding(0) // Remove padding from the VStack inside ScrollView
            }
        }
        .edgesIgnoringSafeArea(.top) // Optional: extends header to top
    }
    
    // Helper to get days of the week
    private var daysOfWeek: [(dayOfWeek: String, date: Date)] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate)) else {
            return []
        }
        return (0..<7).map { index in
            let date = calendar.date(byAdding: .day, value: index, to: startOfWeek)!
            let dayOfWeek = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            return (dayOfWeek, date)
        }
    }
}

extension Date {
    var startOfWeek: Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
    
    var endOfWeek: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? self
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
