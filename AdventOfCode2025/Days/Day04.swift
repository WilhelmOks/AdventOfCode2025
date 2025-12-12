import SwiftUI
import Vector2

private func parseInput(_ input: String) -> Matrix<Bool> {
    let lines = input.split(separator: "\n")
    let columns = lines.first?.count ?? 0
    let rows = lines.count
    
    var grid: Matrix<Bool> = .init(columns: columns, rows: rows, initial: false)
    
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            if char == "@" {
                grid[x, y] = true
            }
        }
    }
    
    return grid
}

private extension Matrix where T == Bool {
    func numberOfNeighbours(x: Int, y: Int) -> Int {
        var count: Int = 0
        
        for dy in -1...1 {
            for dx in -1...1 {
                if dx == 0 && dy == 0 {
                    continue
                }
                if let value = self[x + dx, y + dy], value == true {
                    count += 1
                    if count >= 4 {
                        return count
                    }
                }
            }
        }
        
        return count
    }
}

private extension Matrix where T == Bool {
    func accessibleRolls() -> [IntVector2] {
        var result: [IntVector2] = []
        for x in 0..<columns {
            for y in 0..<rows {
                if self[x, y] == true {
                    let neighbors = self.numberOfNeighbours(x: x, y: y)
                    if neighbors < 4 {
                        result.append(.init(x: x, y: y))
                    }
                }
            }
        }
        return result
    }
}

struct Day04: View {
    @State var matrix: Matrix<Bool>?
    
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        VStack {
            if let matrix {
                let floorColor = Color(hue: 0, saturation: 1, brightness: 0.2)
                let rollColor = Color.yellow
                PlayGrid(rows: matrix.rows, columns: matrix.columns, spacing: 0) { row, column in
                    let color: Color = matrix[column, row] == true ? rollColor : floorColor
                    color
                }
            }
            
            ResultView(
                day: 4,
                calc1: calculate1,
                calc2: calculate2,
            )
        }
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "04")
        /*
        let input: String = """
            ..@@.@@@@.
            @@@.@.@.@@
            @@@@@.@.@@
            @.@@@@..@.
            @@.@@@@.@@
            .@@@@@@@.@
            .@.@.@.@@@
            @.@@@.@@@@
            .@@@@@@@@.
            @.@.@@@.@.
            """
         */
        
        let grid = parseInput(input)
        
        self.matrix = grid
        
        let accessibleRolls = grid.accessibleRolls().count
        
        return String(accessibleRolls)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "04")
        
        var grid = parseInput(input)
        
        var numberOfAccessibleRolls = 0
        var rollsRemoved = 0
        repeat {
            self.matrix = grid
            
            try? await Task.sleep(for: .seconds(0.1))
            
            let accessibleRolls = grid.accessibleRolls()
            numberOfAccessibleRolls = accessibleRolls.count
            
            for location in accessibleRolls {
                grid[location] = false
            }
            
            rollsRemoved += numberOfAccessibleRolls
            
        } while numberOfAccessibleRolls > 0
        
        return String(rollsRemoved)
    }
}

#Preview {
    Day04()
}
