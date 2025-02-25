//
//  StringExtention.swift
//  1chat
//
//  Created by 欧君子 on 2025/2/10.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
}
