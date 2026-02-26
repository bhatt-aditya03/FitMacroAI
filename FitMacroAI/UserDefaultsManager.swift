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
}
