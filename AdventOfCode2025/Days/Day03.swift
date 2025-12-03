import SwiftUI

private func parse(_ input: String) -> [[Int]] {
    input.split(separator: "\n").map { line in line.map { Int(String($0))! }}
}

private func indexOfLargest(_ array: [Int], firstSearch: Bool) -> Int {
    var largest = 0
    var indexOfLargest = -1
    for (index, num) in array.enumerated() {
        if firstSearch && index == array.count - 1 {
            break
        }
        if num > largest {
            largest = num
            indexOfLargest = index
        }
        if num == 9 {
            return index
        }
    }
    return indexOfLargest
}

private func indexOfLargest(_ array: [Int], searchCut: Int) -> Int {
    var largest = 0
    var indexOfLargest = -1
    for (index, num) in array.enumerated() {
        if searchCut > 0 && index == array.count - searchCut {
            break
        }
        if num > largest {
            largest = num
            indexOfLargest = index
        }
        if num == 9 {
            return index
        }
    }
    return indexOfLargest
}

private extension Collection where Element == Int {
    var printedBank: String {
        self.map(String.init).joined(separator: "")
    }
}

private extension Collection where Element == Int64 {
    var positionalSum: Int64 {
        var sum: Int64 = 0
        var power: Int64 = 1
        for num in self.reversed() {
            sum += num * power
            power *= 10
        }
        return sum
    }
}

struct Day03: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 3,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "03")
        let banks = parse(input)
        
        var sum = 0
        
        for bank in banks {
            let indexOfFirst = indexOfLargest(bank, firstSearch: true)
            let restOfBank = Array(bank.dropFirst(indexOfFirst + 1))
            let indexOfSecond = indexOfLargest(restOfBank, firstSearch: false)
            let joltage = bank[indexOfFirst] * 10 + restOfBank[indexOfSecond]
            //print("\(bank.printedBank) -> \(restOfBank.printedBank) | \(indexOfFirst), \(indexOfSecond), \(joltage)")
            sum += joltage
        }
        
        return String(sum)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "03")
        let banks = parse(input)
        
        var sum: Int64 = 0
        
        for bank in banks {
            var batteries = 12
            var restOfBank = bank
            var joltageNumbers: [Int64] = []
            while batteries > 0 {
                let index = indexOfLargest(restOfBank, searchCut: batteries - 1)
                joltageNumbers.append(Int64(restOfBank[index]))
                //print("\(restOfBank.printedBank) -> | \(index)")
                restOfBank = Array(restOfBank.dropFirst(index + 1))
                batteries -= 1
            }
            let joltage = joltageNumbers.positionalSum
            //print("joltage: \(joltage)")
            
            sum += joltage
        }
        
        return String(sum)
    }
}

#Preview {
    Day03()
}
