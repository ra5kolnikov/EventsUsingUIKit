//
//  DateFormatter.swift
//  EventsAppUIKit
//
//  Created by Виталий on 07.06.2023.
//

import Foundation

func formattedDate(date: String) -> String {
    let formatDate = date.contains("UTC") ? "yyyy-MM-dd HH:mm:ss Z" : "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let formatter = DateFormatter()
        formatter.dateFormat = formatDate
        let sourceDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localTime = formatter.string(from: sourceDate!)
        return localTime
}
