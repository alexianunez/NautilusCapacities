import Foundation

@MainActor
class BranchesViewModel: ObservableObject {
    @Published private(set) var branches: [Branch] = []
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
                        return branch1.occupancyName > branch2.occupancyName
                    }
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}
