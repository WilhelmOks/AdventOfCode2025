import SwiftUI

private func parseInput(_ input: String) -> (ranges: [ClosedRange<Int>], ids: [Int]) {
    let lines = input.split(separator: "\n", omittingEmptySubsequences: false).map { $0 }
    
    let parts = lines.split(separator: "")
    let rawRanges = parts.first!
    let rawIds = parts.last!
    
    let ranges = rawRanges.map { raw in
        let rangeParts = raw.split(separator: "-")
        return Int(rangeParts.first!)!...Int(rangeParts.last!)!
    }
    
    let ids = rawIds.map { Int($0)! }
    
    return (ranges: ranges, ids: ids)
}

private extension ClosedRange where Bound == Int {
    /// This merge only works if the `other` range's `lowerBound` is greater than the `lowerBound` of `self`.
    /// So it's suited to be performed on censecutive elements of a sorted collection.
    func merge(_ other: Self) -> Self? {
        if other.lowerBound <= self.upperBound {
            let upper = Swift.max(self.upperBound, other.upperBound)
            return self.lowerBound...upper
        } else {
            return nil
        }
    }
}

struct Day05: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 5,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "05")
        
        let (ranges, ids) = parseInput(input)
        
        let freshIds = ids.filter { id in
            ranges.contains { range in
                range.contains(id)
            }
        }
        
        let numberOfFreshIds = freshIds.count
        
        return String(numberOfFreshIds)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "05")
        /*
        let input = """
            3-5
            10-14
            16-20
            12-18

            1
            5
            8
            11
            17
            32
            """
        */
        
        let (ranges, _) = parseInput(input)
        
        let sortedRanges = ranges.sorted { $0.lowerBound < $1.lowerBound }
        
        let mergedRanges: [ClosedRange<Int>] = sortedRanges.reduce(into: []) { a, b in
            if let last = a.last {
                if let merged = last.merge(b) {
                    a.removeLast()
                    a.append(merged)
                } else {
                    a.append(b)
                }
            } else {
                a.append(b)
            }
        }
        
        let numberOfFreshIds = mergedRanges.reduce(into: 0) { a, b in
            a += b.count
        }
        
        return String(numberOfFreshIds)
    }
}

#Preview {
    Day05()
}
