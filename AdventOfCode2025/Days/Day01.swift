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
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 1,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
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
        
        return String(numberOfZeroes)
    }
    
    func calculate2() async -> String {
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
        
        return String(numberOfZeroes)
    }
}

#Preview {
    Day01()
}
