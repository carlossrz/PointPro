//
//  View+Ext.swift
//  PointPro
//
//  Created by Carlos Suarez on 10/6/25.
//

import SwiftUI

extension View {
    func backgroundGrid(color: Color = .ppBlue,backgroundVersion: BackgroundVersion) -> some View {
        self.modifier(BackgroundModifier(color: color,backgroundVersion: backgroundVersion))
    }
}
