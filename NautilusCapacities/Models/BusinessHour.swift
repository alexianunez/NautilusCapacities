import Foundation

struct BusinessHour: Codable {
    let isClosedAllDay: Bool
    let closingHour: String?
    let dayOfWeek: Int
    let holidayName: String?
    let openingHour: String?
    let isRegularBusinessHours: Bool
    
    enum CodingKeys: String, CodingKey {
        case isClosedAllDay = "ClosedAllDay"
        case closingHour = "ClosingHour"
        case dayOfWeek = "DayOfWeek"
        case holidayName = "HolidayName"
        case openingHour = "OpeningHour"
        case isRegularBusinessHours = "RegularBusinessHours"
    }
}
