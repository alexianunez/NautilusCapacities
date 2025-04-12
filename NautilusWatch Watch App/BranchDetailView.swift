import SwiftUI

struct BranchDetailView: View {
    let branch: Branch
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                CircularProgressView(progress: Double(branch.occupancy) / 100.0)
                    .frame(width: 60, height: 60)
                    .padding(.top, 8)
                
                Text(branch.description)
                    .font(.headline)
                
                Text(branch.address.streetAddress)
                    .font(.caption)
                
                Text("\(branch.address.city), \(branch.address.state) \(branch.address.zipCode)")
                    .font(.caption)
                
                Divider()
                
                Text("Business Hours")
                    .font(.headline)
                
                ForEach(branch.businessHours, id: \.day) { hours in
                    HStack {
                        Text(hours.day)
                            .font(.caption2)
                        Spacer()
                        Text("\(hours.open) - \(hours.close)")
                            .font(.caption2)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}