import SwiftUI
import Foundation

private struct Machine: CustomStringConvertible {
    struct ButtonPresses {
        let buttonIndex: Int
        let presses: Int
    }
    
    let lightsTarget: [Bool]
    var lights: [Bool]
    let buttons: [[Int]]
    let joltageRequirements: [Int]
    
    init(lightsTarget: [Bool], buttons: [[Int]], joltageRequirements: [Int]) {
        self.lightsTarget = lightsTarget
        self.lights = .init(repeating: false, count: lightsTarget.count)
        self.buttons = buttons
        self.joltageRequirements = joltageRequirements
    }
    
    func findLightsSolution() -> [Int] {
        let candidates = combinations(buttons.count)
        for candidate in candidates {
            var copy = self
            //print("TRYING: \(candidate)")
            copy.applyLightsSolution(candidate)
            if copy.lights == copy.lightsTarget {
                return candidate
            }
        }
        return []
    }
    
    mutating func applyLightsSolution(_ lightsSolution: [Int]) {
        for buttonIndex in lightsSolution {
            let lightIndices = buttons[buttonIndex]
            for lightIndex in lightIndices {
                lights[lightIndex].toggle()
            }
        }
    }
    
    func findJoltageSolution() -> [ButtonPresses] {
        return [.init(buttonIndex: 0, presses: 0)]
    }
    
    var description: String {
        let lightsTarget: String = self.lightsTarget.map { $0 ? "#" : "." }.joined()
        let lights: String = self.lights.map { $0 ? "#" : "." }.joined()
        
        let buttons: String = self.buttons.map { button in
            let buttonNumbers = button.map { index in "\(index)" }.joined(separator: ",")
            return "(\(buttonNumbers))"
        }.joined(separator: " ")
        
        let joltageRequirements: String = self.joltageRequirements.map { "\($0)" }.joined(separator: ",")

        return "[\(lightsTarget)] [\(lights)] \(buttons) | {\(joltageRequirements)}"
    }
}

private func parseInput(_ input: String) -> [Machine] {
    let lines = input.split(separator: "\n")
    let machines: [Machine] = lines.map { line in
        let parts = line.split(separator: " ")
        
        let lightsPart = parts.first!
        let joltageRequirementsPart = parts.last!
        let buttonsPart = parts.dropFirst().dropLast()
        
        let trimmedLights = lightsPart.trimmingCharacters(in: .init(charactersIn: "[]"))
        let lightsTarget = trimmedLights.map { $0 == "#" }
        
        let buttons: [[Int]] = buttonsPart.map { button in
            let trimmedButton = button.trimmingCharacters(in: .init(charactersIn: "()"))
            return trimmedButton.split(separator: ",").map { Int($0)! }
        }
        
        let trimmedJoltages = joltageRequirementsPart.trimmingCharacters(in: .init(charactersIn: "{}"))
        let joltages: [Int] = trimmedJoltages.split(separator: ",").map { Int($0)! }
        
        return .init(lightsTarget: lightsTarget, buttons: buttons, joltageRequirements: joltages)
    }
    return machines
}

/// Returns all combinations of sequences of numbers from 0 to n-1, with each number appearing at most once.
/// Sorted by number of elements.
/// Represents the buttons that need to be pressed in sequence to solve the lights on a machine.
/// My assumption is that no button needs to be pressed more than one, since it would unmake the change of the first press.
/// I'm not sure if this assumtion is correct, but it works for part 1 of the puzzle.
private func combinations(_ n: Int) -> AnySequence<[Int]> {
    return AnySequence {
        var size = 0
        var mask = 0
        let maxMask = 1 << n
        return AnyIterator {
            while size <= n {
                while mask < maxMask {
                    let current = mask
                    mask += 1
                    if current.nonzeroBitCount == size {
                        let result = (0..<n).compactMap { (current & (1 << $0)) != 0 ? $0 : nil }
                        return result
                    }
                }
                size += 1
                mask = 0
            }
            return nil
        }
    }
}

extension [Machine.ButtonPresses] {
    func totalNumberOfPresses() -> Int {
        reduce(into: 0) { $0 += $1.presses }
    }
}

struct Day10: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 10,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "10")
        
        /*
        let input = """
            [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
            [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
            [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
            """
         */
        
        let machines = parseInput(input)
        
        //print(machines.map { "\($0)" }.joined(separator: "\n"))
        
        let solvedMachines = machines.map { machine in
            let solution = machine.findLightsSolution()
            guard !solution.isEmpty else {
                fatalError("ERROR: No solution found")
            }
            var solvedMachine = machine
            solvedMachine.applyLightsSolution(solution)
            //print("SOLVED: \(solvedMachine)")
            return (solvedMachine, solution)
        }
        
        //print(solvedMachines.map { "\($0.0)" }.joined(separator: "\n"))
        
        let pressesPerMachine = solvedMachines.map(\.1).map(\.count)
        
        let totalNumberOfPresses = pressesPerMachine.reduce(0, +)
                
        return String(totalNumberOfPresses)
    }
    
    func calculate2() async -> String {
        //let input = readInput(day: "10")
        
        let input = """
            [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
            [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
            [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
            """
        
        let machines = parseInput(input)
        
        //print(machines.map { "\($0)" }.joined(separator: "\n"))
        
        let solutions = machines.map { machine in
            machine.findJoltageSolution()
        }
        
        let pressesPerMachine = solutions.map { $0.totalNumberOfPresses() }
        
        let totalNumberOfPresses = pressesPerMachine.reduce(0, +)
        
        // part 2 is incomplete. I can't figure it out.
                
        return String(totalNumberOfPresses)
    }
}

#Preview {
    Day10()
}
