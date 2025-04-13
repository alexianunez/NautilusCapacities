import Foundation
import Entities

@MainActor
class BranchesViewModel: ObservableObject {
    @Published private(set) var branches: [Branch] = []
    @Published private(set) var branchViewModels: [BranchViewModel] = []
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    
    func fetchBranches() {
        isLoading = true
        error = nil
        
        Task {
            do {
                branches = try await APIClient.shared.fetchBranches()
                    .sorted { branch1, branch2 in
                        // First sort by favorite status
                        if FavoritesManager.shared.isFavorite(branch1) {
                            return true
                        }
                        if FavoritesManager.shared.isFavorite(branch2) {
                            return false
                        }
                        // Then sort by occupancy
                        return branch1.occupancy > branch2.occupancy
                    }
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}
