import SwiftUI

private func parse(from input: String) -> [ClosedRange<Int>] {
    let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return text.split(separator: ",").compactMap { part in
        let pair = part.split(separator: "-")
        if let first = Int(pair.first ?? ""), let last = Int(pair.last ?? "") {
            return first...last
        } else {
            print("Error: couldn't parse \(part)")
            return nil
        }
    }
}

private var factorsCache: [Int: [Int]] = [:]

private func factors(of n: Int) -> [Int] {
    precondition(n > 0, "n must be positive")
    
    if let cached = factorsCache[n] {
        return cached
    }
    
    let sqrtn = Int(Double(n).squareRoot())
    var factors: [Int] = []
    factors.reserveCapacity(2 * sqrtn)
    for i in 1...sqrtn {
        if n % i == 0 {
            factors.append(i)
        }
    }
    var j = factors.count - 1
    if factors[j] * factors[j] == n {
        j -= 1
    }
    while j >= 0 {
        factors.append(n / factors[j])
        j -= 1
    }
    
    factorsCache[n] = factors
    
    return factors
}

private func splitEvenly(_ id: String, into parts: Int) -> [String] {
    if id.count.isMultiple(of: parts) {
        return (0..<parts).map { i in
            let partLength = id.count / parts
            let from = id.index(id.startIndex, offsetBy: i * partLength)
            let to = id.index(id.startIndex, offsetBy: partLength + i * partLength)
            return String(id[from..<to])
        }
    } else {
        return []
    }
}

private func allEqual(parts: [String]) -> Bool {
    Set(parts).count == 1
}

struct Day02: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 2,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "02")
        let ranges = parse(from: input)
        
        var invalidIds: [Int] = []
        
        for range in ranges {
            for number in range {
                let id = String(number)

                let canBeSplitInHalf = id.count.isMultiple(of: 2)
                if canBeSplitInHalf {
                    let firstHalf = id.prefix(id.count / 2)
                    let secondHalf = id.suffix(id.count / 2)
                    
                    if firstHalf == secondHalf {
                        guard let intId = Int(id) else {
                            fatalError("Coudn't convert to Int: \(id)")
                        }
                        invalidIds.append(intId)
                    }
                }
            }
        }
        
        let sum = invalidIds.reduce(0, +)
        
        return String(sum)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "02")
        let ranges = parse(from: input)
        
        var invalidIds: [Int] = []
        
        for range in ranges {
            for number in range {
                let id = String(number)
                guard let intId = Int(id) else {
                    fatalError("Coudn't convert to Int: \(id)")
                }

                let factors = factors(of: id.count).dropFirst()
                
                for factor in factors {
                    let parts = splitEvenly(id, into: Int(factor))
                    if parts.count >= 2 {
                        if allEqual(parts: parts) {
                            invalidIds.append(intId)
                            break
                        }
                    }
                }
            }
        }
        
        let sum = invalidIds.reduce(0, +)
        
        return String(sum)
    }
}

#Preview {
    Day02()
}
