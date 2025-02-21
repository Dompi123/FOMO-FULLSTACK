import SwiftUI

struct PaywallVenueHeader: View {
    let venue: Venue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: venue.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color(Color.gray.opacity(0.3)))
            }
            .frame(height: 200)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(venue.name)
                    .font(.title2)
                    .foregroundColor(Color.primary)
                
                Text(venue.description)
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG
struct PaywallVenueHeader_Previews: PreviewProvider {
    static var previews: some View {
        PaywallVenueHeader(venue: Venue.preview)
            .background(FOMOTheme.Colors.background)
            .previewLayout(.sizeThatFits)
    }
}
#endif 
