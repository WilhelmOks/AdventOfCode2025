import SwiftUI

private enum PathElement: CustomStringConvertible {
    case node(_ elements: [PathElement])
    case leaf
    
    init(id: String, devices: [String: Set<String>]) {
        switch id {
        case "out":
            self = .leaf
        default:
            if let outputIds = devices[id] {
                let nodes = outputIds.map { outputId in
                    PathElement(id: outputId, devices: devices)
                }
                self = .node(nodes)
            } else {
                fatalError("no subpaths for \(id)")
            }
        }
    }
    
    var description: String {
        switch self {
        case .node(let elements):
            return "(\(elements.map(\.description).joined(separator: " ")))"
        case .leaf:
            return "out"
        }
    }
    
    var numberOfPathsToOut: Int {
        switch self {
        case .node(let elements):
            return elements.reduce(0) { $0 + $1.numberOfPathsToOut }
        case .leaf:
            return 1
        }
    }
}

private func parseInput(_ input: String) -> [String: Set<String>] {
    let lines = input.split(separator: "\n")
    var devices: [String: Set<String>] = [:]
    lines.forEach { line in
        let parts = line.split(separator: " ")
        let id = String(parts.first!.dropLast())
        let outputs = Set(parts.dropFirst().map { String($0) })
        devices[id] = outputs
    }
    return devices
}

struct Day11: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 11,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "11")
        /*
        let input = """
            aaa: you hhh
            you: bbb ccc
            bbb: ddd eee
            ccc: ddd eee fff
            ddd: ggg
            eee: out
            fff: out
            ggg: out
            hhh: ccc fff iii
            iii: out
            """
         */
        
        let devices = parseInput(input)
        
        //print(devices.map { "\($0)" }.joined(separator: "\n"))
        
        let path = PathElement(id: "you", devices: devices)
        
        //print(path)
        
        let result = path.numberOfPathsToOut
        
        return String(result)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "11")
        
        return String("??")
    }
}

#Preview {
    Day11()
}
