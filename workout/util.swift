//
//  util.swift
//  workout
//
//  Created by Yury Lebedev on 3/3/25.
//

import Foundation

public func getFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}
