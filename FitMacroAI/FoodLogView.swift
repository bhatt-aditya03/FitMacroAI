import SwiftUI

struct FoodLogView: View {
    
    @State private var foodItems: [FoodItem] = []
    @State private var showingAddFood = false
    @State private var newFoodName: String = ""
    @State private var newFoodCalories: String = ""
    @State private var newFoodProtein: String = ""
    
    var totalCalories: Int {
        foodItems.reduce(0) { $0 + $1.calories }
    }
    
    var totalProtein: Double {
        foodItems.reduce(0) { $0 + $1.protein }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Today's Log")
                    .font(.headline)
                    .foregroundColor(.white)
                HStack(spacing: 40) {
                    VStack {
                        Text("\(totalCalories)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    VStack {
                        Text(String(format: "%.1f g", totalProtein))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Protein")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            
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
                            Text("\(item.calories) cal • \(String(format: "%.1f", item.protein))g protein")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { foodItems.remove(atOffsets: $0) }
                }
                .listStyle(.plain)
            }
            
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
        .navigationTitle("Food Log")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddFood) {
            AddFoodSheet(
                foodName: $newFoodName,
                calories: $newFoodCalories,
                protein: $newFoodProtein
            ) {
                if let cal = Int(newFoodCalories),
                   let pro = Double(newFoodProtein),
                   !newFoodName.isEmpty {
                    foodItems.append(FoodItem(name: newFoodName, calories: cal, protein: pro))
                    newFoodName = ""
                    newFoodCalories = ""
                    newFoodProtein = ""
                }
                showingAddFood = false
            }
        }
    }
}

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Double
}

struct AddFoodSheet: View {
    @Binding var foodName: String
    @Binding var calories: String
    @Binding var protein: String
    let onAdd: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Food Name").font(.caption).foregroundColor(.gray)
                    TextField("e.g. Oats", text: $foodName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Calories").font(.caption).foregroundColor(.gray)
                    TextField("e.g. 350", text: $calories)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Protein (g)").font(.caption).foregroundColor(.gray)
                    TextField("e.g. 12", text: $protein)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                Button(action: onAdd) {
                    Text("Add Food")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
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
