//
//  String+Ext.swift
//  PointPro
//
//  Created by Carlos Suarez on 27/5/25.
//

import Foundation

extension String {
    var localizedValue: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}
