import SwiftUI

struct DayRowView: View {
    @State private var slot1Text: String = ""
    @State private var slot2Text: String = ""
    @State private var slot1FoodName: String? = nil
    @State private var slot2FoodName: String? = nil
    @State private var showIngredientPane: Bool = false
    @State private var selectedFoodName: String = ""

    let dayOfWeek: String
    let date: Date
    
    private let dataManager = DataManager.shared

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    VStack {
                        Text(dayOfWeek)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(dateFormatted)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: 75, height: 100)
                }
                
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            TextField("Enter lunch...", text: $slot1Text, onCommit: {
                                if !slot1Text.isEmpty {
                                    self.slot1FoodName = slot1Text
                                    slot1Text = ""
                                    dataManager.saveFoodName(date: date, foodName: slot1FoodName!)
                                }
                            })
                            .frame(height: 50)
                            .padding(0)
                            .background(Color.clear)
                            .frame(width: UIScreen.main.bounds.width - 75)
                            .opacity(slot1FoodName == nil ? 1 : 0)
                            
                            if let foodName = slot1FoodName {
                                VStack {
                                    HStack {
                                        Image(systemName: "line.horizontal.3")
                                            .padding(.leading, 8)
                                            .foregroundColor(.gray)
                                        
                                        Text(foodName)
                                            .frame(height: 40)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            print("Food name for slot 1: \(foodName)")
                                            self.selectedFoodName = foodName
                                            self.showIngredientPane = true
                                        }) {
                                            Image(systemName: "info.circle")
                                                .padding(8)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Button(action: {
                                            self.slot1FoodName = nil
                                            self.slot1Text = ""
                                            dataManager.removeFoodName(date: date, foodName: foodName)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .padding(8)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 75, height: 33)
                                    .background(Color.green.opacity(0.2))
                                    .border(Color.green, width: 1)
                                    .cornerRadius(17)
                                    .offset(y: -41)
                                }
                                .frame(width: UIScreen.main.bounds.width - 75)
                                .padding(.bottom, -50)
                            }
                        }
                    }
                    .overlay(
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 0.5)
                            .offset(y: 0.5)
                        , alignment: .bottom
                    )

                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            TextField("Enter dinner...", text: $slot2Text, onCommit: {
                                if !slot2Text.isEmpty {
                                    self.slot2FoodName = slot2Text
                                    slot2Text = ""
                                    dataManager.saveFoodName(date: date, foodName: slot2FoodName!)
                                }
                            })
                            .frame(height: 50)
                            .padding(0)
                            .background(Color.clear)
                            .frame(width: UIScreen.main.bounds.width - 75)
                            .opacity(slot2FoodName == nil ? 1 : 0)
                            
                            if let foodName = slot2FoodName {
                                VStack {
                                    HStack {
                                        Image(systemName: "line.horizontal.3")
                                            .padding(.leading, 8)
                                            .foregroundColor(.gray)
                                        
                                        Text(foodName)
                                            .frame(height: 40)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            print("Food name for slot 2: \(foodName)")
                                            self.selectedFoodName = foodName
                                            self.showIngredientPane = true
                                        }) {
                                            Image(systemName: "info.circle")
                                                .padding(8)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Button(action: {
                                            self.slot2FoodName = nil
                                            self.slot2Text = ""
                                            dataManager.removeFoodName(date: date, foodName: foodName)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .padding(8)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 75, height: 33)
                                    .background(Color.green.opacity(0.2))
                                    .border(Color.green, width: 1)
                                    .cornerRadius(16)
                                    .offset(y: -41)
                                }
                                .frame(width: UIScreen.main.bounds.width - 75)
                                .padding(.bottom, -50)
                            }
                        }
                    }
                }
            }
            .overlay(
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
                    .offset(y: 0.5)
                , alignment: .bottom
            )
            .frame(height: 100)
            .sheet(isPresented: $showIngredientPane) {
                IngredientListView(isVisible: $showIngredientPane, selectedFoodName: selectedFoodName)
                    .onAppear {
                        print("Showing ingredient list for: \(selectedFoodName)")
                    }
            }
        }
        .onAppear {
            let savedFoodNames = dataManager.fetchFoodNames(for: date)
            if !savedFoodNames.isEmpty {
                if savedFoodNames.count > 0 {
                    self.slot1FoodName = savedFoodNames[0]
                }
                if savedFoodNames.count > 1 {
                    self.slot2FoodName = savedFoodNames[1]
                }
            }
        }
    }
    
    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
}

struct DayRowView_Previews: PreviewProvider {
    static var previews: some View {
        DayRowView(dayOfWeek: "SUN", date: Date())
    }
}
