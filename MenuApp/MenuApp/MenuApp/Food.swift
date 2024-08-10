import Foundation

struct Food: Identifiable, Codable {
    var id = UUID()
    var name: String
    var ingredients: [String]
}
