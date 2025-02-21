import SwiftUI
import OSLog

struct CheckoutView: View {
    @StateObject private var viewModel: CheckoutViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.previewMode) private var previewMode
    
    init(order: DrinkOrder) {
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(order: order))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.order.items) { item in
                        HStack {
                            Text(item.drink.name)
                            Spacer()
                            Text("$\(Double(truncating: item.drink.price as NSNumber), specifier: "%.2f")")
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("$\(Double(truncating: viewModel.order.total as NSNumber), specifier: "%.2f")")
                                .font(.headline)
                        }
                    }
                }
                
                Button(action: {
                    Task {
                        await viewModel.processOrder()
                        dismiss()
                    }
                }) {
                    if viewModel.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Place Order")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .disabled(viewModel.isProcessing)
                .padding()
            }
            .navigationTitle("Checkout")
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
        }
    }
}

#if DEBUG
struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: DrinkOrder(items: [
            DrinkOrderItem(drink: .mock, quantity: 2),
            DrinkOrderItem(drink: .mock2, quantity: 1)
        ]))
        .environmentObject(PreviewNavigationCoordinator.shared)
        .environment(\.previewMode, true)
        .environment(\.previewPaymentState, .ready)
    }
}
#endif 
