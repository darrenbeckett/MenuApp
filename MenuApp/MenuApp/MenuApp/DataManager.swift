import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let foodNamesKey = "foodNames"
    private let ingredientsKey = "ingredients"

    private init() {}

    // Save food names for a specific date
    func saveFoodName(date: Date, foodName: String) {
        var allFoodNames = fetchFoodNames()
        let dateKey = dateKey(for: date)
        var foodNamesForDate = allFoodNames[dateKey] ?? []
        if !foodNamesForDate.contains(foodName) {
            foodNamesForDate.append(foodName)
        }
        allFoodNames[dateKey] = foodNamesForDate
        saveFoodNames(allFoodNames)
    }
    
    // Remove a specific food name for a specific date
    func removeFoodName(date: Date, foodName: String) {
        var allFoodNames = fetchFoodNames()
        let dateKey = dateKey(for: date)
        var foodNamesForDate = allFoodNames[dateKey] ?? []
        if let index = foodNamesForDate.firstIndex(of: foodName) {
            foodNamesForDate.remove(at: index)
            if foodNamesForDate.isEmpty {
                allFoodNames.removeValue(forKey: dateKey)
            } else {
                allFoodNames[dateKey] = foodNamesForDate
            }
            saveFoodNames(allFoodNames)
        }
    }
    
    // Fetch food names for a specific date
    func fetchFoodNames(for date: Date) -> [String] {
        let allFoodNames = fetchFoodNames()
        let dateKey = dateKey(for: date)
        return allFoodNames[dateKey] ?? []
    }

    
    
    private var ingredientsStorage: [String: [Ingredient]] = [:]
    private var foodIngredients: [String: [Ingredient]] = [:]

    func saveIngredient(for foodName: String, ingredient: Ingredient) {
        var ingredientsDict = fetchIngredientsDict()
        var ingredientsForFood = ingredientsDict[foodName] ?? []
        if let index = ingredientsForFood.firstIndex(where: { $0.id == ingredient.id }) {
            ingredientsForFood[index] = ingredient
        } else {
            ingredientsForFood.append(ingredient)
        }
        ingredientsDict[foodName] = ingredientsForFood
        saveIngredientsDict(ingredientsDict)
    }
    
    func fetchIngredients(for foodName: String) -> [Ingredient] {
        let ingredientsDict = fetchIngredientsDict()
        return ingredientsDict[foodName] ?? []
    }
    
    func removeIngredient(for foodName: String, ingredient: Ingredient) {
        var ingredientsDict = fetchIngredientsDict()
        var ingredientsForFood = ingredientsDict[foodName] ?? []
        ingredientsForFood.removeAll { $0.id == ingredient.id }
        ingredientsDict[foodName] = ingredientsForFood
        saveIngredientsDict(ingredientsDict)
    }
    
    private func fetchIngredientsDict() -> [String: [Ingredient]] {
        guard let data = userDefaults.data(forKey: "IngredientsDict") else {
            return [:]
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([String: [Ingredient]].self, from: data)) ?? [:]
    }
    
    private func saveIngredientsDict(_ ingredientsDict: [String: [Ingredient]]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(ingredientsDict) {
            userDefaults.set(data, forKey: "IngredientsDict")
        }
    }

    func updateIngredient(for foodName: String, ingredient: Ingredient) {
        saveIngredient(for: foodName, ingredient: ingredient)
    }

    
    
    // Helper functions
    private func saveFoodNames(_ foodNames: [String: [String]]) {
        userDefaults.set(try? PropertyListEncoder().encode(foodNames), forKey: foodNamesKey)
    }
    
    private func fetchFoodNames() -> [String: [String]] {
        guard let data = userDefaults.value(forKey: foodNamesKey) as? Data else { return [:] }
        return (try? PropertyListDecoder().decode([String: [String]].self, from: data)) ?? [:]
    }
    
    private func saveIngredients(_ ingredients: [String: [String]]) {
        userDefaults.set(try? PropertyListEncoder().encode(ingredients), forKey: ingredientsKey)
    }
    
    private func fetchIngredients() -> [String: [String]] {
        guard let data = userDefaults.value(forKey: ingredientsKey) as? Data else { return [:] }
        return (try? PropertyListDecoder().decode([String: [String]].self, from: data)) ?? [:]
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
