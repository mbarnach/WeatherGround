import Foundation

/// Type of measures available from the API.
internal enum MeasureType {
    /// The current status of the PWS.
    case current
    /// An hourly-computed list of measures for a day.
    case hourly
    /// The overview for a day of the PWS.
    case daily
    /// An five-minute-computed list of measures for a day.
    case all

    /// Returns the API URL path to retrieve the specific measures.
    internal var historyURL: String {
        switch self {
            case .current: return "/v2/pws/observations/current"
            case .hourly: return "/v2/pws/history/hourly"
            case .daily: return "/v2/pws/history/daily"
            case .all: return "/v2/pws/history/all"
        }
    }
}

/// Internal observations retrieval: wrapper from the API.
internal struct WeatherObservation: Codable {
    let observations: [InstantObservation]
}

/// Describe an observation
public struct InstantObservation: Codable {
    public let stationID: String
    public let obsTimeUtc: String//"2019-12-06T07:26:35Z",
    public let obsTimeLocal: String//"2019-12-06 08:26:35",
    public var obsDateLocal: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from: obsTimeLocal)
    }

    public let neighborhood: String
    public let softwareType: String?
    public let country: String
    public let solarRadiation: Double?
    public let lon: Double
    public let realtimeFrequency: Double?
    public let epoch: Int
    public let lat: Double
    public let uv: Double?
    public let winddir: Int
    public let humidity: Int
    public let qcStatus: Int
    public let metric: InstantMetric
}

/// The metric values for the instant measure (ie. current measures).
public struct InstantMetric: Codable {
    public let temp: Double
    public let heatIndex: Int
    public let dewpt: Double
    public let windChill: Double
    public let windSpeed: Double
    public let windGust: Double
    public let pressure: Double
    public let precipRate: Double
    public let precipTotal: Double
    public let elev: Double
}

/// Internal observations retrieval: wrapper from the API.
internal struct WeatherObservationOverview: Codable {
    let observations: [Observation]
}

/// Historical data retrieved and computed.
public struct Observation: Codable {
    public let stationID: String
    public let tz: String
    public let obsTimeUtc: String//"2019-09-30T22:29:49Z",
    public let obsTimeLocal: String//"2019-10-01 00:29:49",
    public var obsDateLocal: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from: obsTimeLocal)
    }
    public let epoch: Double
    public let lat: Double
    public let lon: Double
    public let solarRadiationHigh: Double?
    public let uvHigh: Double?
    public let winddirAvg: Double
    public let humidityHigh: Double
    public let humidityLow: Double
    public let humidityAvg: Double
    public let qcStatus: Int
    public let metric: Metric
}

public struct Metric: Codable {
    public let tempHigh: Double
    public let tempLow: Double
    public let tempAvg: Double
    public let windspeedHigh: Double
    public let windspeedLow: Double
    public let windspeedAvg: Double
    public let windgustHigh: Double
    public let windgustLow: Double
    public let windgustAvg: Double
    public let dewptHigh: Double
    public let dewptLow: Double
    public let dewptAvg: Double
    public let windchillHigh: Double
    public let windchillLow: Double
    public let windchillAvg: Double
    public let heatindexHigh: Double
    public let heatindexLow: Double
    public let heatindexAvg: Double
    public let pressureMax: Double
    public let pressureMin: Double
    public let pressureTrend: Double?
    public let precipRate: Double
    public let precipTotal: Double
}

