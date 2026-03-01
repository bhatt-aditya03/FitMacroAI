import SwiftUI

struct GoalSetupView: View {
    
    var onComplete: (() -> Void)? = nil
    
    @State private var currentWeight: String = ""
    @State private var targetWeight: String = ""
    @State private var selectedGoal: String = "Lose Weight"
    @State private var dailyCalorieGoal: String = "2000"
    
    let goals = ["Lose Weight", "Gain Muscle", "Stay Fit"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                VStack(spacing: 8) {
                    Text("Setup Your Goal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Tell us about yourself")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Stats")
                        .font(.headline)
                        .padding(.horizontal)
                    
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
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Daily Calorie Goal")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        TextField("e.g. 2000", text: $dailyCalorieGoal)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Goal")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(goals, id: \.self) { goal in
                        HStack {
                            Text(goal).font(.body)
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
                        .onTapGesture { selectedGoal = goal }
                    }
                }
                
                NavigationLink(destination: FoodLogView()) {
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
                .simultaneousGesture(TapGesture().onEnded {
                    if let goal = Int(dailyCalorieGoal) {
                        UserDefaultsManager.saveCalorieGoal(goal)
                    }
                    onComplete?()
                })
            }
        }
        .navigationTitle("Your Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GoalSetupView()
    }
}
