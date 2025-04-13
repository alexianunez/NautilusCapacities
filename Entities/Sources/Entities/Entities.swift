// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct Address: Codable, Sendable {
    public let id: Int
    public let city: String
    public let cityId: Int
    public let country: String
    public let countryId: Int
    public let latitude: Double
    public let longitude: Double
    public let name: String?
    public let phoneNumber: String
    public let postalCode: String
    public let province: String
    public let provinceId: Int
    public let streetAndNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Oid"
        case city = "City"
        case cityId = "CityOid"
        case country = "Country"
        case countryId = "CountryOid"
        case latitude = "Lat"
        case longitude = "Lng"
        case name = "Name"
        case phoneNumber = "PhoneNumber"
        case postalCode = "PostalCode"
        case province = "Province"
        case provinceId = "ProvinceOid"
        case streetAndNumber = "StreetAndNumber"
    }
    
    public init(id: Int, city: String, cityId: Int, country: String, countryId: Int, latitude: Double, longitude: Double, name: String?, phoneNumber: String, postalCode: String, province: String, provinceId: Int, streetAndNumber: String) {
        self.id = id
        self.city = city
        self.cityId = cityId
        self.country = country
        self.countryId = countryId
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.phoneNumber = phoneNumber
        self.postalCode = postalCode
        self.province = province
        self.provinceId = provinceId
        self.streetAndNumber = streetAndNumber
    }
}

public struct BusinessHour: Codable, Sendable {
    public let isClosedAllDay: Bool
    public let closingHour: String?
    public let dayOfWeek: Int
    public let holidayName: String?
    public let openingHour: String?
    public let isRegularBusinessHours: Bool
    
    enum CodingKeys: String, CodingKey {
        case isClosedAllDay = "ClosedAllDay"
        case closingHour = "ClosingHour"
        case dayOfWeek = "DayOfWeek"
        case holidayName = "HolidayName"
        case openingHour = "OpeningHour"
        case isRegularBusinessHours = "RegularBusinessHours"
    }
}

public struct BranchResponse: Codable, Sendable {
    public let success: Bool
    public let data: BranchData
}

public struct BranchData: Codable, Sendable {
    public let branches: [Branch]
    
    enum CodingKeys: String, CodingKey {
        case branches = "Branches"
    }
}

public struct Branch: Codable, Identifiable, Sendable {
    public let id: Int
    public let address: Address
    public let branchNumber: String
    public let occupancy: Int
    public let occupancyColor: String
    public let occupancyName: String
    public let description: String
    public let businessHours: [BusinessHour]
    
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



