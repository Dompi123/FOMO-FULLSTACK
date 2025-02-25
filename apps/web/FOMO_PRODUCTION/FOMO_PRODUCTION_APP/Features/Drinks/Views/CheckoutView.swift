import SwiftUI
import OSLog

struct CheckoutView: View {
    @StateObject private var viewModel: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTip: Int?
    @State private var customTip: String = ""
    @State private var showingPassPresentation = false
    @State private var orderPass: Pass?
    
    init(order: DrinkOrder) {
        _viewModel = StateObject(wrappedValue: CheckoutViewModel(order: order))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Order items
                    VStack(spacing: 16) {
                        ForEach(viewModel.order.items) { item in
                            OrderItemRow(item: item) { count in
                                viewModel.updateItemCount(item, count: count)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Tip section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add Tip ❤️")
                            .font(.headline)
                        
                        Text("All your tips go directly to your bartenders!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Tip options
                        HStack(spacing: 8) {
                            ForEach([1, 2, 3], id: \.self) { amount in
                                TipButton(
                                    amount: amount,
                                    isSelected: selectedTip == amount,
                                    action: { selectedTip = amount }
                                )
                            }
                            
                            // Custom tip
                            TipButton(
                                text: "Other",
                                isSelected: selectedTip == nil && !customTip.isEmpty,
                                action: {
                                    selectedTip = nil
                                    customTip = ""
                                }
                            )
                        }
                        
                        if selectedTip == nil {
                            TextField("Enter custom tip", text: $customTip)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Payment method
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                        
                        HStack {
                            Image("visa-icon") // Add appropriate asset
                                .resizable()
                                .frame(width: 32, height: 20)
                            Text("•••• 4567")
                            Spacer()
                            Button("Switch") {
                                // Handle payment method switch
                            }
                            .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Order summary
                    VStack(spacing: 8) {
                        SummaryRow(title: "Subtotal", amount: viewModel.subtotal)
                        SummaryRow(title: "Tip", amount: viewModel.tipAmount)
                        SummaryRow(title: "Tax & Fees", amount: viewModel.taxAndFees)
                        Divider()
                        SummaryRow(title: "Total", amount: viewModel.total, isTotal: true)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Your Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Drink") {
                        // Handle add drink
                    }
                }
            }
            .safeAreaInset(bottom: {
                Button(action: {
                    Task {
                        if let pass = await viewModel.placeOrder() {
                            orderPass = pass
                            showingPassPresentation = true
                        }
                    }
                }) {
                    HStack {
                        Text("Place Order")
                        Spacer()
                        Text("$\(viewModel.total, specifier: "%.2f")")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
                }
                .background(Color(.systemBackground))
            })
            .fullScreenCover(isPresented: $showingPassPresentation) {
                if let pass = orderPass {
                    PassPresentationView(pass: pass)
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct OrderItemRow: View {
    let item: DrinkOrderItem
    let onCountChanged: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Counter
            HStack {
                Button(action: { onCountChanged(max(0, item.quantity - 1)) }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                }
                
                Text("\(item.quantity)")
                    .frame(width: 30)
                
                Button(action: { onCountChanged(item.quantity + 1) }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.drink.name)
                    .font(.body)
                Text("$\(item.drink.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Remove") {
                onCountChanged(0)
            }
            .foregroundColor(.red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TipButton: View {
    var amount: Int?
    var text: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(amount: Int? = nil, text: String? = nil, isSelected: Bool, action: @escaping () -> Void) {
        self.amount = amount
        self.text = text
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text ?? "$\(amount ?? 0)")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

struct SummaryRow: View {
    let title: String
    let amount: Double
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(isTotal ? .headline : .body)
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .font(isTotal ? .headline : .body)
        }
    }
}

#if DEBUG
struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: .mock)
    }
}
#endif 
