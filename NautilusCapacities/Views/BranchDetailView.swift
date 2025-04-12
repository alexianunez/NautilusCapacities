import SwiftUI
import MapKit

struct BranchDetailView: View {
    let branch: Branch
    @ObservedObject var viewModel: BranchesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var region: MKCoordinateRegion
    @State private var showingMapOptions = false
    
    init(branch: Branch, viewModel: BranchesViewModel) {
        self.branch = branch
        self.viewModel = viewModel
        let coordinate = CLLocationCoordinate2D(
            latitude: branch.address.latitude,
            longitude: branch.address.longitude
        )
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Map View
                Map(coordinateRegion: $region, annotationItems: [branch]) { branch in
                    MapMarker(coordinate: CLLocationCoordinate2D(
                        latitude: branch.address.latitude,
                        longitude: branch.address.longitude
                    ))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture {
                    showingMapOptions = true
                }
                
                // Branch Info
                VStack(alignment: .leading, spacing: 12) {
                    Text(branch.description)
                        .font(.title2)
                        .bold()
                    
                    addressView
                    
                    Button(action: {
                        guard let url = URL(string: "tel://\(branch.address.phoneNumber)"),
                              UIApplication.shared.canOpenURL(url) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Label(branch.address.phoneNumber, systemImage: "phone.fill")
                            .foregroundColor(.blue)
                    }
                    
                    // Occupancy Info
                    HStack {
                        CircularProgressView(progress: Double(branch.occupancy) / 100.0)
                            .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading) {
                            Text("Current Capacity")
                                .font(.headline)
                            Text(branch.occupancyName)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading)
                    }
                    .padding(.top)
                    
                    // Business Hours
                    businessHoursView
                    
                    // Favorite Button
                    Button(action: {
                        FavoritesManager.shared.toggleFavorite(branch)
                        viewModel.fetchBranches()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: FavoritesManager.shared.isFavorite(branch) ? "star.fill" : "star")
                            Text(FavoritesManager.shared.isFavorite(branch) ? "Remove Favorite" : "Set as Favorite")
                        }
                        .foregroundColor(FavoritesManager.shared.isFavorite(branch) ? .yellow : .blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Open in Maps", isPresented: $showingMapOptions, titleVisibility: .visible) {
            Button("Apple Maps") {
                openInMaps(using: .apple)
            }
            Button("Google Maps") {
                openInMaps(using: .google)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var addressView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(branch.address.streetAndNumber)
            Text("\(branch.address.city), \(branch.address.province) \(branch.address.postalCode)")
                .foregroundColor(.secondary)
        }
    }
    
    private var businessHoursView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Business Hours")
                .font(.headline)
            ForEach(branch.businessHours, id: \.dayOfWeek) { hours in
                if let opening = hours.openingHour, let closing = hours.closingHour {
                    HStack {
                        Text(dayName(for: hours.dayOfWeek))
                        Spacer()
                        Text("\(opening) - \(closing)")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                }
            }
        }
    }
    
    private func dayName(for dayOfWeek: Int) -> String {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let normalizedIndex = ((dayOfWeek - 1) % 7 + 7) % 7
        return days[normalizedIndex]
    }
    
    private enum MapType {
        case apple, google
    }
    
    private func openInMaps(using mapType: MapType) {
        let coordinate = "\(branch.address.latitude),\(branch.address.longitude)"
        let name = branch.description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let address = branch.address.streetAndNumber.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        var urlString: String
        
        switch mapType {
        case .apple:
            urlString = "http://maps.apple.com/?q=\(name)&ll=\(coordinate)"
        case .google:
            urlString = "comgooglemaps://?q=\(address)&center=\(coordinate)"
            if !UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                urlString = "https://www.google.com/maps/search/?api=1&query=\(coordinate)"
            }
        }
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
