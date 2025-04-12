import Foundation

struct Address: Codable {
    let id: Int
    let city: String
    let cityId: Int
    let country: String
    let countryId: Int
    let latitude: Double
    let longitude: Double
    let name: String?
    let phoneNumber: String
    let postalCode: String
    let province: String
    let provinceId: Int
    let streetAndNumber: String
    
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
}
