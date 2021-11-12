//
//  NumberFormatter.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/12.
//

import Foundation

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let decimal = NumberFormatter()
        decimal.numberStyle = .decimal
        return decimal
    }
}
