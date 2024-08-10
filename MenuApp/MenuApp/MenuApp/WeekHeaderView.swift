//
//  WeekHeaderView.swift
//  MenuApp
//
//  Created by Darren Beckett on 8/9/24.
//

import SwiftUI

struct WeekHeaderView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        HStack {
            // Previous Week Button
            Button(action: {
                moveWeek(by: -1)
            }) {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .padding()
            }
            .frame(width: 50, alignment: .leading)
            
            Spacer()
            
            // Date Range
            Text(dateRange)
                .font(.headline)
                .padding()
            
            Spacer()
            
            // Next Week Button
            Button(action: {
                moveWeek(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .padding()
            }
            .frame(width: 50, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(0)
        .safeAreaInset(edge: .top, content: {
                    Color.clear.frame(height: 20) // Adjust height if needed
                })
    }
    
    private var dateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
    
    private func moveWeek(by offset: Int) {
        let calendar = Calendar.current
        if let newStartDate = calendar.date(byAdding: .weekOfYear, value: offset, to: startDate),
           let newEndDate = calendar.date(byAdding: .weekOfYear, value: offset, to: endDate) {
            startDate = newStartDate
            endDate = newEndDate
        }
    }
}

struct WeekHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        WeekHeaderView(startDate: .constant(Date().startOfWeek), endDate: .constant(Date().endOfWeek))
    }
}
