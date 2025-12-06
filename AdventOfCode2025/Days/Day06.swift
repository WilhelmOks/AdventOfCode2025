import SwiftUI

struct Day06: View {
    var body: some View {
        content()
    }
    
    @ViewBuilder private func content() -> some View {
        ResultView(
            day: 6,
            calc1: calculate1,
            calc2: calculate2,
        )
        .padding()
    }
    
    func calculate1() async -> String {
        let input = readInput(day: "06")
        
        return String("?")
    }
    
    func calculate2() async -> String {
        let input = readInput(day: "06")
        
        return String("??")
    }
}

#Preview {
    Day06()
}
