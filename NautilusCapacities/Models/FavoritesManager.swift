import Foundation
import WidgetKit

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "FavoriteBranchId"
    
    private let userDefaults: UserDefaults = {
        if let defaults = UserDefaults(suiteName: "group.com.alexianunez.nautiluscapacities") {
            return defaults
        }
        return UserDefaults.standard
    }()
    
    private init() {}
    
    var favoriteBranchId: Int? {
        get {
            userDefaults.integer(forKey: favoritesKey)
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: favoritesKey)
            } else {
                userDefaults.removeObject(forKey: favoritesKey)
            }
            WidgetCenter.shared.reloadAllTimelines()
#if os(watchOS)
            WidgetCenter.shared.reloadTimelines(
                ofKind: "com.alexianunez.NautilusCapacities.watchkitapp.WidgetComplication"
            )
#endif
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
