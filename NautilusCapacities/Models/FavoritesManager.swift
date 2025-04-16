import Foundation
import WidgetKit

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "FavoriteBranchId"
    
    private init() {}
    
    var favoriteBranchId: Int? {
        get {
            UserDefaults.standard.integer(forKey: favoritesKey)
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: favoritesKey)
            } else {
                UserDefaults.standard.removeObject(forKey: favoritesKey)
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func isFavorite(_ branch: Branch) -> Bool {
        return branch.id == favoriteBranchId
    }
    
    func toggleFavorite(_ branch: Branch) {
        if isFavorite(branch) {
            favoriteBranchId = nil
        } else {
            favoriteBranchId = branch.id
        }
    }
}
