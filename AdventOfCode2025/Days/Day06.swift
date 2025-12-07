import SwiftUI

private enum Operator: CustomStringConvertible {
    case addition
    case multiplication
    
    var description: String {
        switch self {
        case .addition: return "+"
        case .multiplication: return "*"
        }
    }
}

private func parseInput(_ input: String) -> (numbers: [[Int]], operators: [Operator]) {
    let lines = input.split(separator: "\n")
    let numberLines = lines.dropLast()
    let operatorLine = lines.last!
    
    let numbers: [[Int]] = numberLines.map { line in
        line.split(separator: " ").map { Int($0)! }
    }
    
    let operators: [Operator] = operatorLine.split(separator: " ").map {
        $0 == "+" ? .addition : .multiplication
    }
    
    return (numbers: numbers, operators: operators)
}

private func parseInput2(_ input: String) -> (numbers: [[Int]], operators: [Operator]) {
    let lines = input.split(separator: "\n")
    let numberLines = lines.dropLast()
    let operatorLine = lines.last!
    
    var allOpStrings: [String] = []
    var currentOpString = " "
    for char in operatorLine.reversed() {
        currentOpString += String(char)
        if char != " " {
            allOpStrings.append(currentOpString)
            currentOpString = ""
        }
    }
    
    let opInfos = allOpStrings.reversed().map { opString in
        let opChar = opString.trimmingCharacters(in: .whitespacesAndNewlines)
        let op: Operator = opChar == "+" ? .addition : .multiplication
        return (operator: op, length: opString.count - 1)
    }
    
    let blocks = numberLines.map { line in
        var spans: [String] = []
        var currentLine = line
        for opInfo in opInfos {
            spans.append(String(currentLine.prefix(opInfo.length)))
            currentLine = currentLine.dropFirst(opInfo.length + 1)
        }
        return spans
    }
    
    //print("blocks:\n\(blocks)")
    
    let transposedBlocks = blocks.transposed().map {
        $0.transposed().map { numberString in
            var s = numberString
            s.removeAll(where: { $0 == " " })
            return Int(s)!
        }
    }
    
    //print("transposedBlocks:\n\(transposedBlocks)")
    
    return (numbers: transposedBlocks, operators: opInfos.map { $0.operator })
}

private extension [[Int]] {
    func transposed() -> Self {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

private extension [[String]] {
    func transposed() -> Self {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

private extension [String] {
    func transposed() -> Self {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            String(self.map{ $0[index] })
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
        let input = readInput(day: "06", trim: false)
        /*
        let input = """
            123 328  51 64 
             45 64  387 23 
              6 98  215 314
            *   +   *   +  
            """
         */
        
        let (numbers, operators) = parseInput2(input)
        
        var results: [Int] = []
        for (opIndex, op) in operators.enumerated() {
            let blockNumbers = numbers[opIndex]
            let opIsPlus = op == .addition
            let initial = opIsPlus ? 0 : 1
            let r = blockNumbers.reduce(into: initial) { result, number in
                if opIsPlus {
                    result += number
                } else {
                    result *= number
                }
            }
            results.append(r)
        }
        
        let grandTotal = results.reduce(0, +)
        
        return String(grandTotal)
    }
}

#Preview {
    Day06()
}
