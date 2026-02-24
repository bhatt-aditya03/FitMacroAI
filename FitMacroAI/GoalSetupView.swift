import SwiftUI

struct GoalSetupView: View {
    
    @State private var currentWeight: String = ""
    @State private var targetWeight: String = ""
    @State private var selectedGoal: String = "Lose Weight"
    
    let goals = ["Lose Weight", "Gain Muscle", "Stay Fit"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Header
                VStack(spacing: 8) {
                    Text("Setup Your Goal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Tell us about yourself")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // Weight Input Section
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Your Stats")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Current Weight
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Current Weight (kg)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        TextField("e.g. 70", text: $currentWeight)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // Target Weight
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Target Weight (kg)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        TextField("e.g. 65", text: $targetWeight)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                // Goal Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Goal")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(goals, id: \.self) { goal in
                        HStack {
                            Text(goal)
                                .font(.body)
                            Spacer()
                            if selectedGoal == goal {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(selectedGoal == goal ? Color.green.opacity(0.1) : Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onTapGesture {
                            selectedGoal = goal
                        }
                    }
                }
                
                // Continue Button
                Button(action: {
                    print("Goal set: \(selectedGoal), \(currentWeight)kg -> \(targetWeight)kg")
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
            }
        }
    }
}

#Preview {
    GoalSetupView()
}
