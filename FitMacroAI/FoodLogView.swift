import SwiftUI

// MARK: - Data Models
struct FoodItem: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let servingSize: String
}

struct FoodAnalysisRequest: Codable {
    let food_description: String
    let quantity: String
}

struct FoodAnalysisResponse: Codable {
    let food_name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let serving_size: String
}

// MARK: - API Service
class FoodAPIService {
    static let shared = FoodAPIService()
    let baseURL = "https://web-production-f32bc.up.railway.app"
    
    func analyzeFood(description: String, quantity: String) async throws -> FoodAnalysisResponse {
        let url = URL(string: "\(baseURL)/analyze-food")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = FoodAnalysisRequest(food_description: description, quantity: quantity)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(FoodAnalysisResponse.self, from: data)
    }
}

// MARK: - Main Food Log View
struct FoodLogView: View {
    
    @State private var foodItems: [FoodItem] = UserDefaultsManager.loadFoodItems()
    @State private var showingAddFood = false
    @State private var foodDescription = ""
    @State private var quantity = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    
    var totalCalories: Int {
        foodItems.reduce(0) { $0 + $1.calories }
    }
    var totalProtein: Double {
        foodItems.reduce(0) { $0 + $1.protein }
    }
    var totalCarbs: Double {
        foodItems.reduce(0) { $0 + $1.carbs }
    }
    var totalFat: Double {
        foodItems.reduce(0) { $0 + $1.fat }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Summary Card
            VStack(spacing: 12) {
                Text("Today's Log")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // 4 Macros Row
                HStack(spacing: 16) {
                    VStack {
                        Text("\(totalCalories)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Cal")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Divider().background(Color.white.opacity(0.5)).frame(height: 35)
                    VStack {
                        Text(String(format: "%.1fg", totalProtein))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Protein")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Divider().background(Color.white.opacity(0.5)).frame(height: 35)
                    VStack {
                        Text(String(format: "%.1fg", totalCarbs))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Carbs")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Divider().background(Color.white.opacity(0.5)).frame(height: 35)
                    VStack {
                        Text(String(format: "%.1fg", totalFat))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Fat")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Progress Bar
                let calorieGoal = UserDefaultsManager.loadCalorieGoal()
                let progress = min(Double(totalCalories) / Double(calorieGoal), 1.0)
                
                VStack(spacing: 4) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 8)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: geo.size.width * progress, height: 8)
                        }
                    }
                    .frame(height: 8)
                    Text("\(totalCalories) / \(calorieGoal) cal")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            
            // Food List
            if foodItems.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "fork.knife")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No food logged yet")
                        .foregroundColor(.gray)
                    Text("Tap + to add food")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                    Spacer()
                }
            } else {
                List {
                    ForEach(foodItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .fontWeight(.medium)
                            Text("\(item.calories) cal • P: \(String(format: "%.1f", item.protein))g • C: \(String(format: "%.1f", item.carbs))g • F: \(String(format: "%.1f", item.fat))g")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { foodItems.remove(atOffsets: $0) }
                }
                .listStyle(.plain)
            }
            
            // Add Food Button
            Button(action: { showingAddFood = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Food").fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
            }
            .padding()
        }
        .onAppear {
            if UserDefaultsManager.shouldResetForNewDay() {
                foodItems = []
                UserDefaultsManager.clearFoodItems()
            }
            UserDefaultsManager.updateLastLogDate()
        }
        
        .navigationTitle("Food Log")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddFood) {
            AIFoodInputSheet(
                foodDescription: $foodDescription,
                quantity: $quantity,
                isLoading: $isLoading
            ) {
                await addFood()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }
    
    func addFood() async {
        guard !foodDescription.isEmpty else { return }
        isLoading = true
        
        do {
            let response = try await FoodAPIService.shared.analyzeFood(
                description: foodDescription,
                quantity: quantity.isEmpty ? "1 serving" : quantity
            )
            
            let newItem = FoodItem(
                name: response.food_name,
                calories: response.calories,
                protein: response.protein,
                carbs: response.carbs,
                fat: response.fat,
                servingSize: response.serving_size
            )
            
            await MainActor.run {
                foodItems.append(newItem)
                UserDefaultsManager.saveFoodItems(self.foodItems)
                foodDescription = ""
                quantity = ""
                isLoading = false
                showingAddFood = false
            }
        } catch {
            await MainActor.run {
                errorMessage = "Could not analyze food. Check your connection."
                showError = true
                isLoading = false
            }
        }
    }
}

// MARK: - AI Food Input Sheet
struct AIFoodInputSheet: View {
    @Binding var foodDescription: String
    @Binding var quantity: String
    @Binding var isLoading: Bool
    let onAdd: () async -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.green)
                    Text("AI-Powered Analysis")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("What did you eat?")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("e.g. rajma chawal, dal makhani, oats", text: $foodDescription)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("How much? (optional)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("e.g. 1 katori, 2 rotis, 1 plate", text: $quantity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    Task { await onAdd() }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView().tint(.white)
                            Text("Analyzing...").foregroundColor(.white)
                        } else {
                            Image(systemName: "sparkles")
                            Text("Analyze & Add").fontWeight(.semibold)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isLoading ? Color.gray : Color.green)
                    .cornerRadius(12)
                }
                .disabled(isLoading || foodDescription.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        FoodLogView()
    }
}
