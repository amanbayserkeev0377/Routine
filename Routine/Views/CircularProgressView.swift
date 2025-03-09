import SwiftUI

struct CircularProgressView: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 10)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: progress)
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    CircularProgressView(progress: 0.5)
}
