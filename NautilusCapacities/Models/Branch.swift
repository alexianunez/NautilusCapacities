import Foundation

struct BranchResponse: Codable {
    let success: Bool
    let data: BranchData
}

struct BranchData: Codable {
    let branches: [Branch]
    
    enum CodingKeys: String, CodingKey {
        case branches = "Branches"
    }
}

struct Branch: Codable, Identifiable {
    let id: Int
    let address: Address
    let branchNumber: String
    let occupancy: Int
    let occupancyColor: String
    let occupancyName: String
    let description: String
    let businessHours: [BusinessHour]
    
    enum CodingKeys: String, CodingKey {
        case id = "Oid"
        case address = "Address"
        case branchNumber = "BranchNumber"
        case occupancy = "Occupancy"
        case occupancyColor = "OccupancyColor"
        case occupancyName = "OccupancyName"
        case description = "Description"
        case businessHours = "BusinessHours"
    }
}
