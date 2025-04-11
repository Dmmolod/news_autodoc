//
//  DateFormatter.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import Foundation


public struct DateFormat: ExpressibleByStringLiteral {
    let rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public extension Date {
    func toFormat(_ format: DateFormat) -> String {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}

public extension DateFormat {
    /// format: 16:51 (HH:mm)
    static let hhmm: DateFormat = "HH:mm"
    
    /// format: 01 Января 2020 (dd MMMM yyyy)
    static let ddmmmmyyyy: DateFormat = "dd MMMM yyyy"
    
    /// format: 01 Января 2020 в 16:51 (dd MMMM yyyy в HH:mm)
    static let ddmmyyyyinhhmm = DateFormat(stringLiteral: ddmmmmyyyy.rawValue + " в " + hhmm.rawValue)
    
    /// format 2024-12-20T09:45:00 (yyyy-MM.ddTHH:mm:ss)
    static let iso8601: DateFormat = "yyyy-MM-dd'T'HH:mm:ss"
}

public extension String {
    func toDate(with format: DateFormat) -> Date? {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: String(self.prefix(format.rawValue.count)))
    }
}

private let dateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    
    return formatter
}()
