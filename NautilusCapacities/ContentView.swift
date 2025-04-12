import SwiftUI
import Entities

struct ContentView: View {
    @StateObject private var viewModel = BranchesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        // Favorite Branch Section
                        if let favoriteBranch = viewModel.branches.first(where: { FavoritesManager.shared.isFavorite($0) }) {
                            Section("Favorite") {
                                NavigationLink {
                                    BranchDetailView(branch: favoriteBranch, viewModel: viewModel)
                                } label: {
                                    BranchCapacityRow(branch: favoriteBranch)
                                }
                            }
                        }
                        
                        // All Branches Section
                        Section("All Branches") {
                            ForEach(viewModel.branches.filter { !FavoritesManager.shared.isFavorite($0) }) { branch in
                                NavigationLink {
                                    BranchDetailView(branch: branch, viewModel: viewModel)
                                } label: {
                                    BranchCapacityRow(branch: branch)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Branch Capacities")
        }
        .task {
            viewModel.fetchBranches()
        }.refreshable {
            viewModel.fetchBranches()
        }
    }
}

struct BranchCapacityRow: View {
    let branch: Branch
    
    var body: some View {
        HStack {
            CircularProgressView(progress: Double(branch.occupancy) / 100.0)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(branch.description)
                    .font(.headline)
                Text(branch.address.city)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(.subheadline, design: .rounded))
                .bold()
        }
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.5:
            return .green
        case 0.5..<0.8:
            return .yellow
        default:
            return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
