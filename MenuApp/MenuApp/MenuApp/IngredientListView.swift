import SwiftUI


struct IngredientListView: View {
    @Binding var isVisible: Bool
    @State private var newIngredient: String = ""
    @State private var ingredients: [Ingredient] = []
    var selectedFoodName: String

    private let dataManager = DataManager.shared

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add new ingredient...", text: $newIngredient, onCommit: addNewIngredient)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: addNewIngredient) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }
                
                List {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            IngredientStateView(state: ingredient.state)
                                .onTapGesture {
                                    updateIngredientState(for: ingredient)
                                }
                            
                            Text(ingredient.name)
                        }
                    }
                    .onDelete(perform: deleteIngredients)
                }
                .navigationTitle("Ingredients for \(selectedFoodName)")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            isVisible = false
                        }
                    }
                }
                .onAppear {
                    // Load existing ingredients for the selected food
                    loadIngredients()
                }
            }
        }
    }
    
    private func addNewIngredient() {
        guard !newIngredient.isEmpty else { return }
        
        let ingredient = Ingredient(id: UUID(), name: newIngredient, state: .empty)
        dataManager.saveIngredient(for: selectedFoodName, ingredient: ingredient)
        ingredients.append(ingredient)
        newIngredient = ""
    }
    
    private func updateIngredientState(for ingredient: Ingredient) {
        guard let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) else { return }
        
        var updatedIngredient = ingredient
        switch updatedIngredient.state {
        case .empty:
            updatedIngredient.state = .checked
        case .checked:
            updatedIngredient.state = .withPlus
        case .withPlus:
            updatedIngredient.state = .empty
        }
        
        dataManager.saveIngredient(for: selectedFoodName, ingredient: updatedIngredient)
        ingredients[index] = updatedIngredient
    }
    
    private func deleteIngredients(at offsets: IndexSet) {
        for index in offsets {
            let ingredient = ingredients[index]
            dataManager.removeIngredient(for: selectedFoodName, ingredient: ingredient)
        }
        ingredients.remove(atOffsets: offsets)
    }
    
    private func loadIngredients() {
        ingredients = dataManager.fetchIngredients(for: selectedFoodName)
    }
}

struct IngredientStateView: View {
    var state: IngredientState

    var body: some View {
        switch state {
        case .empty:
            Image(systemName: "circle")
                .foregroundColor(.gray)
        case .checked:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .withPlus:
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
        }
    }
}

struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListView(
            isVisible: .constant(true),
            selectedFoodName: "Pizza"
        )
    }
}
