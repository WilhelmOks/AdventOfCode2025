import SwiftUI

private enum PathElement: CustomStringConvertible {
    case node(_ id: String, _ elements: [PathElement], _ passedNodesInfo: PassedNodesInfo)
    case leaf(isOut: Bool, _ passedNodesInfo: PassedNodesInfo)
    
    init(id: String, devices: [String: Set<String>], passedNodesInfo: PassedNodesInfo) {
        var changedInfo = passedNodesInfo
        changedInfo.visited.insert(id)
        if id == "dac" {
            changedInfo.dac = true
        } else if id == "fft" {
            changedInfo.fft = true
        }
        
        switch id {
        case "out":
            self = .leaf(isOut: true, changedInfo)
        case let visitedId where passedNodesInfo.visited.contains(visitedId):
            self = .leaf(isOut: false, changedInfo)
        default:
            if let outputIds = devices[id]?.subtracting(changedInfo.visited) {
                let nodes: [Self] = outputIds.compactMap { outputId in
                    //print("BUILDING id:\(id), outputId:\(outputId), visited: \(passedNodesInfo.visited)")
                    if passedNodesInfo.visited.contains(outputId) {
                        //return PathElement.leaf(isOut: false, changedInfo)
                        return nil
                    } else {
                        return PathElement(id: outputId, devices: devices, passedNodesInfo: changedInfo)
                    }
                }
                if nodes.isEmpty {
                    self = .leaf(isOut: false, changedInfo)
                } else {
                    self = .node(id, nodes, changedInfo)
                }
            } else {
                fatalError("no outputs for \(id)")
            }
        }
    }
    
    var description: String {
        switch self {
        case .node(let id, let elements, _):
            //return "\(id) \(elements.map(\.description).joined(separator: " "))"
            return "\(id) \(elements.reduce("") { $0 + $1.description })"
        case .leaf:
            return "out\n"
        }
    }
    
    var numberOfPathsToOut: Int {
        switch self {
        case .node(_, let elements, _):
            return elements.reduce(0) { $0 + $1.numberOfPathsToOut }
        case .leaf(let isOut, _):
            return isOut ? 1 : 0
        }
    }
    
    var numberOfPathsToOutPassingPart2Requirements: Int {
        switch self {
        case .node(_, let elements, _):
            return elements.reduce(0) { $0 + $1.numberOfPathsToOutPassingPart2Requirements }
        case .leaf(let isOut, let info):
            return isOut && info.dac && info.fft ? 1 : 0
        }
    }
}

private struct PassedNodesInfo: Hashable {
    var fft: Bool
    var dac: Bool
    var visited: Set<String> = []
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
        return "-"
        
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
        
        let path = PathElement(id: "you", devices: devices, passedNodesInfo: .init(fft: false, dac: false))
        
        //print(path)
        
        let result = path.numberOfPathsToOut
        
        return String(result)
    }
    
    func calculate2() async -> String {
        //return "--"
        
        let input = readInput(day: "11")
        /*
        let input = """
            svr: aaa bbb
            aaa: fft
            fft: ccc
            bbb: tty
            tty: ccc
            ccc: ddd eee
            ddd: hub
            hub: fff
            eee: dac
            dac: fff
            fff: ggg hhh
            ggg: out
            hhh: out
            """
         */
        
        let devices = parseInput(input)
        
        let path = PathElement(id: "svr", devices: devices, passedNodesInfo: .init(fft: false, dac: false))
        
        print(path)
        
        let result = path.numberOfPathsToOutPassingPart2Requirements
        //let result = path.numberOfPathsToOut
        
        // part 2 is incomplete: endless loop in PathElement.init()
        
        return String(result)
    }
}

#Preview {
    Day11()
}
