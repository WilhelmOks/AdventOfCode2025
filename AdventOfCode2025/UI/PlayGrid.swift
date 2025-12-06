//
//  PlayGrid.swift
//  AdventOfCode2025
//
//  Created by Wilhelm Oks on 27.11.25.
//

import SwiftUI

struct PlayGrid<Cell: View>: View {
    let rows: Int
    let columns: Int
    var spacing: CGFloat = 3
    @ViewBuilder let cell: (Int, Int) -> Cell
    
    var body: some View {
        Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                GridRow {
                    ForEach(0..<columns, id: \.self) { column in
                        cell(row, column)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity
                            )
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }
}

#Preview {
    PlayGrid(rows: 7, columns: 5) { x, y in
        Group {
            if x == 2 && y == 3 {
                Image(systemName: "star.fill")
                    .foregroundStyle(.red)
            } else {
                Text("\(x),\(y)")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.opacity(0.2))
    }
}
