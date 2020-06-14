import Foundation

extension Date {
    public var weather: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyMMdd"
        return dateFormatter.string(from: self)
    }
}