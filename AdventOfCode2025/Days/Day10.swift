import SwiftUI
import Foundation

private struct Machine: CustomStringConvertible {
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
        //let input = readInput(day: "10")
        
        let input = """
            [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
            [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
            [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
            """
        
        let machines = parseInput(input)
        
        print(machines.map { "\($0)" }.joined(separator: "\n"))
        
        return String("?")
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "10")
        
        return String("??")
    }
}

#Preview {
    Day10()
}
