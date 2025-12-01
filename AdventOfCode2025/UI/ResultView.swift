//
//  ResultView.swift
//  AdventOfCode2025
//
//  Created by Wilhelm Oks on 01.12.25.
//

import SwiftUI

struct ResultView: View {
    let day: Int
    @State var result1: String?
    @State var result2: String?
    let calc1: () async -> String
    let calc2: () async -> String
    
    var body: some View {
        content()
            .task {
                async let r1 = calc1()
                async let r2 = calc2()
                (result1, result2) = await (r1, r2)
                
                print("-----\nDay \(day)")
                print("P1: \(result1!)")
                print("P2: \(result2!)")
            }
    }
    
    @ViewBuilder private func content() -> some View {
        VStack(spacing: 20) {
            Text("Day \(day)")
                .font(.largeTitle)
            
            HStack(spacing: 20) {
                result(title: "Part 1", value: result1)
                result(title: "Part 2", value: result2)
            }
        }
    }
    
    @ViewBuilder private func result(title: String, value: String?) -> some View {
        VStack {
            Text(title)
            
            if let value {
                ZStack {
                    Text(value).bold()
                    ProgressView().hidden()
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .glassEffect()
    }
}

#Preview {
    ResultView(
        day: 42,
        calc1: { "abc" },
        calc2: { "123" },
    )
}
