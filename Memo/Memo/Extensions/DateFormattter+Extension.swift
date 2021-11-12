//
//  DateFormattter+Extension.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/12.
//

import Foundation

extension DateFormatter {
    // 오늘 : 오전 08:19
    // 이번주 : 일요일, 화요일
    // 그외: 2021. 10. 25 02:33,
    static var normalFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. MM. dd a hh:mm"
        return formatter
    }
    
    static var thisWeekFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEE"
        return formatter
    }
    
    static var todayFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "a hh:mm"
        return formatter
    }
    
    static func getDateString(date: Date) -> String {
        let calendar = Calendar.current
        
        // 오늘
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter.todayFormat
            return formatter.string(from: date)
        }
        
        // 어제
        else if calendar.isDateInYesterday(date) {
            return "어제"
        }
        
        // 이번주
        else if calendar.isDateInWeekend(date) {
            let formmatter  = DateFormatter.thisWeekFormat
            return formmatter.string(from: date)
        }
        
        let formatter = DateFormatter.normalFormat
        return formatter.string(from: date)
    }
}
