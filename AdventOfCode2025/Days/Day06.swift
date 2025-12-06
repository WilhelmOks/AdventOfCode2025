import SwiftUI

private enum Operator {
    case addition
    case multiplication
}

private func parseInput(_ input: String) -> (numbers: [[Int]], operators: [Operator]) {
    let lines = input.split(separator: "\n")
    let numberLines = lines.dropLast()
    let operatorLine = lines.last!
    
    let numbers: [[Int]] = numberLines.map { line in
        line.split(separator: " ").map { Int($0)! }
    }
    
    let operators: [Operator] = operatorLine.split(separator: " ").map { $0 == "+" ? .addition : .multiplication }
    
    return (numbers: numbers, operators: operators)
}

private extension [[Int]] {
    func transposed() -> Self {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

struct Day06: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 6,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "06")
        /*
        let input = """
            123 328  51 64 
             45 64  387 23 
              6 98  215 314
            *   +   *   +  
            """
         */
        
        let (numbers, operators) = parseInput(input)
        
        let transposedNumbers = numbers.transposed()
        
        let numberOfColumns = operators.count
        let columnResults = (0..<numberOfColumns).map { index in
            let opIsPlus = operators[index] == .addition
            let initial = opIsPlus ? 0 : 1
            return transposedNumbers[index].reduce(into: initial) { result, number in
                if opIsPlus {
                    result += number
                } else {
                    result *= number
                }
            }
        }
        
        let grandTotal = columnResults.reduce(0, +)
        
        return String(grandTotal)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "06")
        
        return String("??")
    }
}

#Preview {
    Day06()
}
