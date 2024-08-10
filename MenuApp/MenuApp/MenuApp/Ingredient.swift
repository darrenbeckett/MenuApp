import Foundation

enum IngredientState: Int, Codable {
    case empty
    case checked
    case withPlus
}

struct Ingredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var state: IngredientState
}
