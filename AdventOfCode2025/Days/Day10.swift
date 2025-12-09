import SwiftUI

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
