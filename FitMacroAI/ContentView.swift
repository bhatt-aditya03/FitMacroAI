import SwiftUI

struct ContentView: View {
    @State private var showGoalSetup = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("FitMacro AI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("Your Personal AI Fitness Agent")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Spacer()
                
                NavigationLink(destination: GoalSetupView()) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
