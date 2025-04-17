//
//  ViewModels.swift
//  NautilusCapacities
//
//  Created by Alexia Nunez on 4/13/25.
//

struct BranchViewModel: Sendable {
    let id: Int
    let address: AddressViewModel
    let branchNumber: String
    let occupancy: Int
    let occupancyColor: String
    let occupancyName: String
    let description: String
    let businessHours: [BusinessHourViewModel]
    
    init(branch: Branch) {
        self.id = branch.id
        self.address = AddressViewModel(address: branch.address)
        self.branchNumber = branch.branchNumber
        self.occupancy = branch.occupancy
        self.occupancyColor = branch.occupancyColor
        self.occupancyName = branch.occupancyName
        self.description = branch.description
        self.businessHours = branch.businessHours.map { BusinessHourViewModel(businessHour: $0) }
    }
}

struct AddressViewModel: Sendable {
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
    
    init(address: Address) {
        self.id = address.id
        self.city = address.city
        self.cityId = address.cityId
        self.country = address.country
        self.countryId = address.countryId
        self.latitude = address.latitude
        self.longitude = address.longitude
        self.name = address.name
        self.phoneNumber = address.phoneNumber
        self.postalCode = address.postalCode
        self.province = address.province
        self.provinceId = address.provinceId
        self.streetAndNumber = address.streetAndNumber
    }
}

struct BusinessHourViewModel: Sendable {
    let isClosedAllDay: Bool
    let closingHour: String?
    let dayOfWeek: Int
    let holidayName: String?
    let openingHour: String?
    let isRegularBusinessHours: Bool
    
    
    init(businessHour: BusinessHour) {
        self.isClosedAllDay = businessHour.isClosedAllDay
        self.closingHour = businessHour.closingHour
        self.dayOfWeek = businessHour.dayOfWeek
        self.holidayName = businessHour.holidayName
        self.openingHour = businessHour.openingHour
        self.isRegularBusinessHours = businessHour.isRegularBusinessHours
    }
}
