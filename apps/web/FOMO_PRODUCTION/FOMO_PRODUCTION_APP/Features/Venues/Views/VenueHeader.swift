import SwiftUI

struct VenueHeader: View {
    let venue: Venue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(venue.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(venue.description)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct VenueHeader_Previews: PreviewProvider {
    static var previews: some View {
        VenueHeader(venue: .preview)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif 