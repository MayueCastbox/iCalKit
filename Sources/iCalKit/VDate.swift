//
//  VDate.swift
//  iCalKit
//
//  Created by Valentin Dusollier on 20/08/2020.
//

import Foundation

public struct VDate {
    public let rawValue: String
}

extension VDate {
    public func toDate() -> Date? {
        return iCal.dateFormatter.date(from: self.rawValue)
    }
    
    public static func fromDate(_ date: Date) -> VDate {
        return VDate(rawValue: iCal.dateFormatter.string(from: date))
    }
}

extension VDate: Equatable {
    public static func == (lhs: VDate, rhs: VDate) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
