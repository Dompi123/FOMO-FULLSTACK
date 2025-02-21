import SwiftUI
import OSLog

struct DrinkMenuView: View {
    @StateObject private var viewModel = DrinkMenuViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDrinks: Set<String> = []
    @State private var showCheckout = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                } else if viewModel.menuItems.isEmpty {
                    ContentUnavailableView("No Drinks Available",
                        systemImage: "wineglass",
                        description: Text("The drink menu is currently empty.")
                    )
                } else {
                    List {
                        ForEach(viewModel.menuItems) { drink in
                            DrinkRowView(
                                drink: drink,
                                isSelected: selectedDrinks.contains(drink.id)
                            ) {
                                if selectedDrinks.contains(drink.id) {
                                    selectedDrinks.remove(drink.id)
                                } else {
                                    selectedDrinks.insert(drink.id)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Drink Menu")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
                
                if !selectedDrinks.isEmpty {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Checkout (\(selectedDrinks.count))") {
                            let items = viewModel.menuItems
                                .filter { selectedDrinks.contains($0.id) }
                                .map { DrinkOrderItem(drink: $0) }
                            viewModel.createOrder(items: items)
                            showCheckout = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .sheet(isPresented: $showCheckout) {
                if let order = viewModel.currentOrder {
                    CheckoutView(order: order)
                }
            }
        }
    }
}

#if DEBUG
struct DrinkMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkMenuView()
    }
}
#endif 