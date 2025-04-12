import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BranchesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.branches) { branch in
                            NavigationLink {
                                BranchDetailView(branch: branch)
                            } label: {
                                BranchRow(branch: branch)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Branches")
        }
        .task {
            viewModel.fetchBranches()
        }
    }
}

struct BranchRow: View {
    let branch: Branch
    
    var body: some View {
        HStack {
            CircularProgressView(progress: Double(branch.occupancy) / 100.0)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(branch.description)
                    .font(.caption)
                    .lineLimit(1)
                Text(branch.address.city)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 10, design: .rounded))
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