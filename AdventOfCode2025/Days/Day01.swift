//
//  Day01.swift
//  AdventOfCode2025
//
//  Created by Wilhelm Oks on 01.12.25.
//

import SwiftUI

private struct Action {
    enum Direction {
        case left, right
    }
    
    let direction: Direction
    let number: Int
}

private func actions(from input: String) -> [Action] {
    input.split(separator: "\n").map { line in
        let letter = line.first ?? "?"
        let number = Int(line.dropFirst()) ?? 0
        
        return Action(
            direction: letter == "R" ? .right : .left,
            number: number,
        )
    }
}

struct Day01: View {
    @State var result = ""
    
    var body: some View {
        content()
            .onAppear(perform: calculate)
    }
    
    @ViewBuilder private func content() -> some View {
        VStack(spacing: 20) {
            Text("Day 1")
                .font(.title)
            
            HStack {
                Text("Result: \(result)")
            }
        }
    }
    
    func calculate() {
        let input = readInput(day: "01")
        let actions = actions(from: input)
        var number = 50
        var numberOfZeroes = 0
        
        for action in actions {
            switch action.direction {
            case .left:
                number -= action.number
                while number < 0 {
                    number += 100
                }
            case .right:
                number += action.number
                while number > 99 {
                    number -= 100
                }
            }
            if number == 0 {
                numberOfZeroes += 1
            }
        }
        
        result = String(numberOfZeroes)
        print(result)
    }
}

#Preview {
    Day01()
}
