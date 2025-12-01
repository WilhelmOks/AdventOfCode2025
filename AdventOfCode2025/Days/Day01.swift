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
    @State var result1 = ""
    @State var result2 = ""
    
    var body: some View {
        content()
            .onAppear {
                calculate1()
                calculate2()
            }
    }
    
    @ViewBuilder private func content() -> some View {
        VStack(spacing: 20) {
            Text("Day 1")
                .font(.title)
            
            Text("Result part 1: \(result1)")
            Text("Result part 2: \(result2)")
        }
    }
    
    func calculate1() {
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
        
        result1 = String(numberOfZeroes)
        print("P1: " + result1)
    }
    
    func calculate2() {
        let input = readInput(day: "01")
        let actions = actions(from: input)
        var number = 50
        var numberOfZeroes = 0
        
        for action in actions {
            switch action.direction {
            case .left:
                for _ in 1...action.number {
                    number -= 1
                    if number < 0 {
                        number = 99
                    }
                    if number == 0 {
                        numberOfZeroes += 1
                    }
                }
            case .right:
                for _ in 1...action.number {
                    number += 1
                    if number > 99 {
                        number = 0
                    }
                    if number == 0 {
                        numberOfZeroes += 1
                    }
                }
            }
        }
        
        result2 = String(numberOfZeroes)
        print("P2: " + result2)
    }
}

#Preview {
    Day01()
}
