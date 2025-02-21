import SwiftUI
import OSLog

struct DrinkRowView: View {
    let drink: DrinkItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(drink.name)
                        .font(.headline)
                    Text(drink.formattedPrice)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

#if DEBUG
struct DrinkRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DrinkRowView(
                drink: DrinkItem(
                    id: "preview_drink",
                    name: "Preview Drink",
                    description: "A delicious preview drink",
                    price: 9.99,
                    quantity: 1
                ),
                isSelected: true
            ) {}
        }
        .environmentObject(PreviewNavigationCoordinator.shared)
        .environment(\.previewMode, true)
    }
}
#endif 
