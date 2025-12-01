//
//  ResultView.swift
//  AdventOfCode2025
//
//  Created by Wilhelm Oks on 01.12.25.
//

import SwiftUI

struct ResultView: View {
    let day: Int
    let result1: String
    let result2: String
    
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        VStack(spacing: 20) {
            Text("Day \(day)")
                .font(.largeTitle)
            
            result(title: "Result part 1", value: result1)
            result(title: "Result part 2", value: result2)
        }
    }
    
    @ViewBuilder private func result(title: String, value: String) -> some View {
        VStack {
            Text(title)
            Text(value).bold()
        }
        .padding()
        .glassEffect()
    }
}

#Preview {
    ResultView(
        day: 7,
        result1: "abc",
        result2: "123",
    )
}
