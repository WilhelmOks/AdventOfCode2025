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

struct Day02: View {
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
        
        return "?"
    }
}

#Preview {
    Day02()
}
