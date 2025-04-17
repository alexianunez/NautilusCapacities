import SwiftUI
import WidgetKit

struct BranchDetailView: View {
    let branch: Branch
    @ObservedObject var viewModel: BranchesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Occupancy Info
                HStack {
                    CircularProgressView(progress: Double(branch.occupancy) / 100.0)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        Text("Current Capacity")
                            .font(.caption)
                        Text(branch.occupancyName)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 4)
                
                Divider()
                
                // Branch Info
                Group {
                    Text(branch.description)
                        .font(.caption)
                        .bold()
                    
                    Text(branch.address.streetAndNumber)
                        .font(.caption2)
                    Text("\(branch.address.city), \(branch.address.province)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Link("📞 \(branch.address.phoneNumber)", destination: URL(string: "tel:\(branch.address.phoneNumber)")!)
                        .font(.caption2)
                }
                
                Divider()
                
                // Business Hours
                Group {
                    Text("Hours")
                        .font(.caption)
                        .bold()
                    
                    ForEach(branch.businessHours, id: \.dayOfWeek) { hours in
                        if let opening = hours.openingHour, let closing = hours.closingHour {
                            HStack {
                                Text(dayName(for: hours.dayOfWeek))
                                    .font(.caption2)
                                Spacer()
                                Text("\(opening) - \(closing)")
                                    .font(.caption2)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Favorite Button
                Button(action: {
                    FavoritesManager.shared.toggleFavorite(branch)
                    
                    viewModel.fetchBranches() // This will now update the shared view model
                    WidgetCenter.shared.reloadAllTimelines()
                    dismiss() // Return to list to see the update
                }) {
                    HStack {
                        Image(systemName: FavoritesManager.shared.isFavorite(branch) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                        Text(FavoritesManager.shared.isFavorite(branch) ? "Remove Favorite" : "Set as Favorite")
                            .font(.caption2)
                    }
                }
                .buttonStyle(.bordered)
                .tint(FavoritesManager.shared.isFavorite(branch) ? .yellow : .blue)
                .padding(.top, 8)
            }
            .padding()
        }
    }
    
    private func dayName(for dayOfWeek: Int) -> String {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let normalizedIndex = ((dayOfWeek - 1) % 7 + 7) % 7
        return days[normalizedIndex]
    }
}
