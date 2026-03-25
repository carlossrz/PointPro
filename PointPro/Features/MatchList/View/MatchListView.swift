//
//  MatchListView.swift
//  PointPro
//
//  Created by Carlos Suarez on 21/5/25.
//

import SwiftUI
import SwiftData

struct MatchListView: View {
    @Query(sort: \MatchData.date,order: .reverse) private var matches: [MatchData]
    @Environment(\.modelContext) private var context
    
    @State var showCreate: Bool = false
    @State private var matchEdit: MatchData?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(matches) { match in
                    NavigationLink(destination: MatchDetailView(match: .constant(match))) {
                        PPMatchCell(matchData: match,cellType: .menu)
                    }
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: deleteMatches)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreate = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreate) {
                CreateMatchData(newMatch: .constant(MatchData()))
                    .presentationDragIndicator(.visible)
            }
            .sheet(item: $matchEdit) { item in
                MatchDetailView(match: .constant(item))
            }
            .navigationTitle("text.matchList")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deleteMatches(at offsets: IndexSet) {
        for index in offsets {
            context.delete(matches[index])
        }
        try? context.save()
    }
}


#Preview {
    MatchListView()
}


struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
