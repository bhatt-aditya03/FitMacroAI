import Foundation

class UserDefaultsManager {
    
    static let foodItemsKey = "saved_food_items"
    
    static func saveFoodItems(_ items: [FoodItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: foodItemsKey)
        }
    }
    
    static func loadFoodItems() -> [FoodItem] {
        if let data = UserDefaults.standard.data(forKey: foodItemsKey),
           let decoded = try? JSONDecoder().decode([FoodItem].self, from: data) {
            return decoded
        }
        return []
    }
    
    static func clearFoodItems() {
        UserDefaults.standard.removeObject(forKey: foodItemsKey)
    }
    
    // Calorie Goal
    static let calorieGoalKey = "calorie_goal"

    static func saveCalorieGoal(_ goal: Int) {
        UserDefaults.standard.set(goal, forKey: calorieGoalKey)
    }

    static func loadCalorieGoal() -> Int {
        let goal = UserDefaults.standard.integer(forKey: calorieGoalKey)
        return goal == 0 ? 2000 : goal
    }
    
    // Daily Reset
        static let lastLogDateKey = "last_log_date"
        
        static func shouldResetForNewDay() -> Bool {
            let today = Calendar.current.startOfDay(for: Date())
            
            if let savedDate = UserDefaults.standard.object(forKey: lastLogDateKey) as? Date {
                return savedDate < today
            }
            return false
        }
        
        static func updateLastLogDate() {
            let today = Calendar.current.startOfDay(for: Date())
            UserDefaults.standard.set(today, forKey: lastLogDateKey)
        }
    
    // Onboarding
    static let onboardingKey = "is_onboarding_complete"

    static func setOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    static func isOnboardingComplete() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    // User Profile
    static let currentWeightKey = "current_weight"
    static let targetWeightKey = "target_weight"
    static let selectedGoalKey = "selected_goal"

    static func saveUserProfile(currentWeight: String, targetWeight: String, selectedGoal: String) {
        UserDefaults.standard.set(currentWeight, forKey: currentWeightKey)
        UserDefaults.standard.set(targetWeight, forKey: targetWeightKey)
        UserDefaults.standard.set(selectedGoal, forKey: selectedGoalKey)
    }

    static func loadCurrentWeight() -> String {
        return UserDefaults.standard.string(forKey: currentWeightKey) ?? ""
    }

    static func loadTargetWeight() -> String {
        return UserDefaults.standard.string(forKey: targetWeightKey) ?? ""
    }

    static func loadSelectedGoal() -> String {
        return UserDefaults.standard.string(forKey: selectedGoalKey) ?? "Lose Weight"
    }
}
