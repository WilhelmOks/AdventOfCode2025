import SwiftUI

private struct Position: Equatable, Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    let z: Int
    
    func distSquared(to other: Position) -> Int {
        let dx = x - other.x
        let dy = y - other.y
        let dz = z - other.z
        return dx * dx + dy * dy + dz * dz
    }
    
    var description: String {
        "(\(x),\(y),\(z))"
    }
}

private struct Distance: Hashable, Equatable, CustomStringConvertible {
    let pos1: CircuitPos
    let pos2: CircuitPos
    let dist: Int
    
    init(pos1: CircuitPos, pos2: CircuitPos) {
        self.pos1 = pos1
        self.pos2 = pos2
        self.dist = pos1.pos.distSquared(to: pos2.pos)
    }
    
    var description: String {
        "\(pos1) <-> \(pos2) = \(dist)"
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        let sameOrder = lhs.pos1 == rhs.pos1 && lhs.pos2 == rhs.pos2
        let reversedOrder = lhs.pos1 == rhs.pos2 && lhs.pos2 == rhs.pos1
        return (sameOrder || reversedOrder) && lhs.dist == rhs.dist
    }
    
    func hash(into hasher: inout Hasher) {
        let a = pos1.hashValue
        let b = pos2.hashValue
        if a <= b {
            hasher.combine(pos1)
            hasher.combine(pos2)
        } else {
            hasher.combine(pos2)
            hasher.combine(pos1)
        }
        hasher.combine(dist)
    }
}

private struct CircuitPos: Hashable, CustomStringConvertible {
    let circuitIndex: Int
    let posIndex: Int
    let pos: Position
    
    var description: String {
        "\(circuitIndex)|\(posIndex):\(pos)"
    }
}

private func parseInput(_ input: String) -> [Position] {
    let lines = input.split(separator: "\n")
    let positions = lines.map { line in
        let parts = line.split(separator: ",")
        return Position(x: Int(parts[0])!, y: Int(parts[1])!, z: Int(parts[2])!)
    }
    return positions
}

private func iteratePositions(circuits: [[Position]], skipCircuitIndex: Int? = nil, yield: (CircuitPos) -> Void) {
    for (circuitIndex, circuit) in circuits.enumerated() {
        if let skipCircuitIndex, skipCircuitIndex == circuitIndex {
            return
        }
        for (posIndex, pos) in circuit.enumerated() {
            yield(.init(circuitIndex: circuitIndex, posIndex: posIndex, pos: pos))
        }
    }
}

private extension [[Position]] {
    func find(pos: Position) -> CircuitPos {
        for (circuitIndex, circuit) in enumerated() {
            for (posIndex, currentPos) in circuit.enumerated() {
                if pos == currentPos {
                    return .init(circuitIndex: circuitIndex, posIndex: posIndex, pos: pos)
                }
            }
        }
        fatalError("Not found: \(pos)")
    }
}

struct Day08: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 8,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "08")
        /*
        let input = """
            162,817,812
            57,618,57
            906,360,560
            592,479,940
            352,342,300
            466,668,158
            542,29,236
            431,825,988
            739,650,466
            52,470,668
            216,146,977
            819,987,18
            117,168,530
            805,96,715
            346,949,466
            970,615,88
            941,993,340
            862,61,35
            984,92,344
            425,690,689
            """
         */
        
        let positoins = parseInput(input)
        
        var circuits: [[Position]] = positoins.map { [$0] }
        
        var distances: Set<Distance> = []
        iteratePositions(circuits: circuits) { pos in
            iteratePositions(circuits: circuits) { otherPos in
                if pos != otherPos {
                    let distance = Distance(pos1: pos, pos2: otherPos)
                    if !distances.contains(distance) {
                        distances.insert(distance)
                    }
                }
            }
            //print("paired: \(pos.circuitIndex)")
        }
        
        let numberOfConnectionsToMake = 1000
        var connectionsMade = 0
        
        let sortedDistances = distances.sorted { $0.dist < $1.dist }
        
        for distance in sortedDistances {
            let pos1 = circuits.find(pos: distance.pos1.pos)
            let pos2 = circuits.find(pos: distance.pos2.pos)
            
            if pos1.circuitIndex != pos2.circuitIndex {
                circuits[pos1.circuitIndex] += circuits[pos2.circuitIndex]
                circuits.remove(at: pos2.circuitIndex)
            }
            connectionsMade += 1 //even if the connection wasn't made because it's in the same circuit already, we need to count it towards the total number of connections, otherwise the solution will be wrong.
            
            //print("connectionsMade: \(connectionsMade)")
            
            if connectionsMade == numberOfConnectionsToMake {
                break
            }
        }
        
        let numberOfLargestCircuitstoMultiply = 3
        let largestCircuits = circuits.sorted { $0.count > $1.count }.prefix(numberOfLargestCircuitstoMultiply)
        let product = largestCircuits.reduce(1) { $0 * $1.count }
        
        return String(product)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "08")
        
        let positoins = parseInput(input)
        
        var circuits: [[Position]] = positoins.map { [$0] }
        
        var distances: Set<Distance> = []
        iteratePositions(circuits: circuits) { pos in
            iteratePositions(circuits: circuits) { otherPos in
                if pos != otherPos {
                    let distance = Distance(pos1: pos, pos2: otherPos)
                    if !distances.contains(distance) {
                        distances.insert(distance)
                    }
                }
            }
        }
        
        let sortedDistances = distances.sorted { $0.dist < $1.dist }
        
        var wallDistance = 0
        
        for distance in sortedDistances {
            let pos1 = circuits.find(pos: distance.pos1.pos)
            let pos2 = circuits.find(pos: distance.pos2.pos)
            
            if pos1.circuitIndex != pos2.circuitIndex {
                circuits[pos1.circuitIndex] += circuits[pos2.circuitIndex]
                circuits.remove(at: pos2.circuitIndex)
            }
            
            if circuits.count == 1 {
                wallDistance = pos1.pos.x * pos2.pos.x
                break
            }
        }
        
        return String(wallDistance)
    }
}

#Preview {
    Day08()
}

