import SwiftUI

private enum Part {
    case empty
    case start
    case splitter
    case beam(_ number: Int)
}

private func parseInput(_ input: String) -> Matrix<Part> {
    let lines = input.split(separator: "\n")
    let columns = lines.first!.count
    let rows = lines.count
    
    var matrix: Matrix<Part> = .init(rows: rows, columns: columns, initial: .empty)
    
    for (y, line) in lines.enumerated() {
        for (x, char) in line.enumerated() {
            let part: Part = switch char {
            case "S": .start
            case "^": .splitter
            default: .empty
            }
            matrix[x, y] = part
        }
    }
    
    return matrix
}

struct Day07: View {
    @State private var matrix: Matrix<Part>?
    
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        VStack {
            if let matrix {
                PlayGrid(rows: matrix.rows, columns: matrix.columns, spacing: 0) { row, column in
                    if let part = matrix[column, row] {
                        switch part {
                        case .empty:
                            Color.black
                        case .start:
                            Color.orange
                        case .splitter:
                            Color.cyan
                        case .beam(let number):
                            ZStack {
                                Color.yellow
                                //Text("\(number)")
                            }
                        }
                    }
                }
            }
            
            ResultView(
                day: 7,
                calc1: calculate1,
                calc2: calculate2,
            )
        }
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "07")
        
        var matrix = parseInput(input)
        
        var numberOfSplits = 0
        
        for row in 0..<matrix.rows {
            columnLoop: for col in 0..<matrix.columns {
                let abovePart = matrix[col, row - 1]
                if let part = matrix[col, row] {
                    switch abovePart {
                    case .start:
                        matrix[col, row] = .beam(1)
                        break columnLoop
                    case .splitter:
                        break
                    case .beam:
                        switch part {
                        case .splitter:
                            matrix[col - 1, row] = .beam(1)
                            matrix[col + 1, row] = .beam(1)
                            numberOfSplits += 1
                        default:
                            matrix[col, row] = .beam(1)
                        }
                    case .empty:
                        break
                    case nil:
                        break
                    }
                }
            }
            //self.matrix = matrix
            //try? await Task.sleep(for: .seconds(0.1))
        }
        
        return String(numberOfSplits)
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "07")
        /*
        let input = """
            .......S.......
            ...............
            .......^.......
            ...............
            ......^.^......
            ...............
            .....^.^.^.....
            ...............
            ....^.^...^....
            ...............
            ...^.^...^.^...
            ...............
            ..^...^.....^..
            ...............
            .^.^.^.^.^...^.
            ...............
            """
         */
        
        var matrix = parseInput(input)
        
        var numberTimelines = 1
        
        for row in 0..<matrix.rows {
            columnLoop: for col in 0..<matrix.columns {
                let abovePart = matrix[col, row - 1]
                if let part = matrix[col, row] {
                    switch abovePart {
                    case .start:
                        matrix[col, row] = .beam(1)
                        break columnLoop
                    case .splitter:
                        break
                    case .beam(let beamNumber):
                        switch part {
                        case .splitter:
                            if case .beam(let existingBeamNumber) = matrix[col - 1, row] {
                                matrix[col - 1, row] = .beam(beamNumber + existingBeamNumber)
                            } else {
                                matrix[col - 1, row] = .beam(beamNumber)
                            }
                            
                            matrix[col + 1, row] = .beam(beamNumber)
                            
                            numberTimelines += beamNumber
                        case .beam(let existingBeamNumber):
                            matrix[col, row] = .beam(beamNumber + existingBeamNumber)
                        default:
                            matrix[col, row] = .beam(beamNumber)
                        }
                    case .empty:
                        break
                    case nil:
                        break
                    }
                }
            }
            self.matrix = matrix
            //try? await Task.sleep(for: .seconds(0.1))
        }
        
        return String(numberTimelines)
    }
}

#Preview {
    Day07()
}
