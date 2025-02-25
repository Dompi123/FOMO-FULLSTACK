import SwiftUI
import OSLog

struct DrinkMenuView: View {
    @StateObject private var viewModel = DrinkMenuViewModel()
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Search bar
                SearchBar(text: $searchText, placeholder: "What do you want to drink?")
                    .padding(.horizontal)
                
                // Categories section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Categories")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryButton(
                                icon: "arrow.clockwise",
                                title: "Order Again",
                                color: .blue
                            )
                            
                            CategoryButton(
                                icon: "wineglass",
                                title: "Signatures",
                                color: .red
                            )
                            
                            CategoryButton(
                                icon: "bottle",
                                title: "Bottled Beer",
                                color: .orange
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Order Again section
                if !viewModel.recentDrinks.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Order Again")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.recentDrinks) { drink in
                                    DrinkCard(drink: drink)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Featured drinks
                VStack(alignment: .leading, spacing: 16) {
                    Text("Signatures")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.signatureDrinks) { drink in
                            DrinkRow(drink: drink)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Drink Menu")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

// MARK: - Supporting Views
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct CategoryButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.caption)
        }
        .foregroundColor(.white)
        .frame(width: 80, height: 80)
        .background(color)
        .cornerRadius(12)
    }
}

struct DrinkCard: View {
    let drink: Drink
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Drink image
            Image(drink.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(8)
            
            Text(drink.name)
                .font(.subheadline)
                .lineLimit(1)
            
            Text("$\(drink.price, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
    }
}

struct DrinkRow: View {
    let drink: Drink
    
    var body: some View {
        HStack(spacing: 16) {
            // Drink image
            Image(drink.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(drink.name)
                    .font(.body)
                Text("$\(drink.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Add to cart
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#if DEBUG
struct DrinkMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DrinkMenuView()
        }
    }
}
#endif 