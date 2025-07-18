//
//  PPSectionCard.swift
//  PointPro
//
//  Created by Carlos Suarez on 13/6/25.
//

import SwiftUI

struct PPSectionCard<Content: View>: View {
    let title: String?
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title, !title.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.ppBlue)
            }
            content()
        }
        .padding()
        .background(Color(.lightGray).opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    PPSectionCard(title: "Estadisticas") {
        VStack(alignment: .leading) {
            Text("Ganados: 10")
            Text("Perdidos: 2")
        }
    }
}
