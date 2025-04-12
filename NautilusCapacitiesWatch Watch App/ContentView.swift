//
//  ContentView.swift
//  NautilusCapacitiesWatch Watch App
//
//  Created by Alexia Nunez on 4/11/25.
//

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
        }
    }
}

struct BranchCapacityRow: View {
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
            .padding(.leading, 4)
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
                .font(.system(.caption2, design: .rounded))
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

#Preview {
    ContentView()
}
