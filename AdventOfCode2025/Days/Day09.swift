import SwiftUI
import Vector2
import CoreGraphics

private func readInput(_ input: String) -> [IntVector2] {
    let lines = input.split(separator: "\n")
    let vectors: [IntVector2] = lines.map { line in
        let parts = line.split(separator: ",")
        return .init(x: Int(parts.first!)!, y: Int(parts.last!)!)
    }
    
    return vectors
}

private struct Rect: Hashable {
    let vMin: IntVector2
    let vMax: IntVector2
    
    var width: Int {
        vMax.x - vMin.x + 1
    }
    
    var height: Int {
        vMax.y - vMin.y + 1
    }
    
    init(v1: IntVector2, v2: IntVector2) {
        vMin = .init(x: min(v1.x, v2.x), y: min(v1.y, v2.y))
        vMax = .init(x: max(v1.x, v2.x), y: max(v1.y, v2.y))
    }
    
    func corners() -> [IntVector2] {
        [
            .init(x: vMin.x, y: vMin.y),
            .init(x: vMax.x, y: vMin.y),
            .init(x: vMin.x, y: vMax.y),
            .init(x: vMax.x, y: vMax.y),
        ]
    }
    
    func area() -> Int {
        (vMax.x - vMin.x + 1) * (vMax.y - vMin.y + 1)
    }
    
    func contains(_ other: Self) -> Bool {
        vMin.x <= other.vMin.x && vMax.x >= other.vMax.x && vMin.y <= other.vMin.y && vMax.y >= other.vMax.y
    }
}

private extension IntVector2 {
    func area(_ other: IntVector2) -> Int {
        let dx = abs(self.x - other.x) + 1
        let dy = abs(self.y - other.y) + 1
        return dx * dy
    }
}

private struct Blob: Shape {
    let paths: [Path]
    
    func path(in rect: CGRect) -> Path {
        //let path = paths.reduce(into: Path()) { a, b in a = a.union(b) }
        let path = paths.reduce(into: Path()) { a, b in a.addPath(b) }
        return path
    }
}

struct Day09: View {
    var body: some View {
        content()
    }
    
    let path1 = {
        var path = Path()
        path.addEllipse(in: .init(x: 10, y: 20, width: 100, height: 200))
        return path
    }()
    
    let path2 = {
        var path = Path()
        path.addEllipse(in: .init(x: 50, y: 20, width: 100, height: 200))
        return path
    }()
    
    @State var paths: [Path] = []
    
    @ViewBuilder private func content() -> some View {
        VStack {
            /*
            Blob(paths: self.paths)
                .stroke()
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
             */
            
            ResultView(
                day: 9,
                calc1: calculate1,
                calc2: calculate2,
            )
        }
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "09")
        /*
        let input = """
            7,1
            11,1
            11,7
            9,7
            9,5
            2,5
            2,3
            7,3
            """
         */
        
        let vectors = readInput(input)
        
        //print(vectors.map { $0.description }.joined(separator: " "))
        
        var maxArea: Int = 0
        
        for vector in vectors {
            for otherVector in vectors {
                if vector == otherVector { continue }
                let area = vector.area(otherVector)
                if area > maxArea {
                    maxArea = area
                    //print("# \(vector.description) \(otherVector.description) -> \(maxArea)")
                }
            }
        }
        
        return String(maxArea)
    }
    
    func calculate2_try1() async -> String {
        //let input = readInput(day: "09")
        
        let input = """
            7,1
            11,1
            11,7
            9,7
            9,5
            2,5
            2,3
            7,3
            """
        
        let vectors = Set(readInput(input))
        
        var paths: [Path] = []
        
        for vector in vectors {
            for otherVector in vectors {
                if vector == otherVector { continue }
                
                let rect = Rect(v1: vector, v2: otherVector)
                var path = Path()
                let scale: CGFloat = 10.0
                path.addRect(
                    CGRect(
                        x: CGFloat(rect.vMin.x) * scale,
                        y: CGFloat(rect.vMin.y) * scale,
                        width: CGFloat(rect.width) * scale,
                        height: CGFloat(rect.height) * scale
                    )
                )
                paths.append(path)
            }
        }
        
        self.paths = paths
        
        return String("??")
    }
    
    func calculate2() async -> String {
        //let input = readInput(day: "09")
        
        let input = """
            7,1
            11,1
            11,7
            9,7
            9,5
            2,5
            2,3
            7,3
            """
        
        let vectors = Set(readInput(input))
        var rects: Set<Rect> = []
        
        for vector in vectors {
            for otherVector in vectors {
                if vector == otherVector { continue }
                let rect = Rect(v1: vector, v2: otherVector)
                rects.insert(rect)
            }
        }
        
        let sortedRects = rects.sorted { (lhs, rhs) in
            lhs.area() > rhs.area()
        }
        
        let largestRect = sortedRects.first { rect in
            vectors.isSuperset(of: rect.corners())
        }
        
        let largestArea = largestRect?.area() ?? -1
        
        //this is wrong and incomplete
        
        return String(largestArea)
    }
}

#Preview {
    Day09()
}
