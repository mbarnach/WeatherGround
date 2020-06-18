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
    /// Five day forecast
    case fiveDayForecast

    /// Returns the API URL path to retrieve the specific measures.
    internal var endpoint: String {
        switch self {
            case .current: return "/v2/pws/observations/current"
            case .hourly: return "/v2/pws/history/hourly"
            case .daily: return "/v2/pws/history/daily"
            case .all: return "/v2/pws/history/all"
            case .fiveDayForecast: return "/v3/wx/forecast/daily/5day"
        }
    }
}

public enum Location {
    /// GPS location.
    case geo(latitude: Double, longitude: Double)
    /// 3 letter code.
    case iata(airport: String)
    /// 4 letter code.
    case icao(airport: String)
    /// A place ID (as defined on Google Maps?)
    case place(id: String)
    /// Postal code with country: 81657:US
    case postal(zip: String)
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

/// A metric observations.
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

public enum MoonPhase: String, Codable, CustomStringConvertible {
    case WNG
    case WXC
    case FQ
    case WNC
    case LQ
    case F
    case WXG
    case N

    public var description: String {
        switch self {
        case .WNG: return "Waning Gibbous"
        case .WXC: return "Waxing Crescent"
        case .FQ: return "First Quarter"
        case .WNC: return "Waning Crescent"
        case .LQ: return "Last Quarter"
        case .F: return "Full Moon"
        case .WXG: return "Waxing Crescent"
        case .N: return "New Moon"
        }
    }
}

/// 5 Day Daily Forecast object.
/// The TWC daily forecast product can contain multiple days of daily forecasts for each location.
/// Each day of a forecast can contain up to (3) "temporal segments" meaning three separate forecasts.
/// For any given forecast day we offer day, night, and a 24-hour forecast (daily summary).
/// Implementing our forecasts requires your applications to perform basic processing in order to properly ingest the forecast data feeds.
/// The data values in this API are correctly populated into Day, Night, or 24-hour temporal segments.
/// These segments are separate objects in the response.
/// PLEASE NOTE: The daypart object as well as the temperatureMax field OUTSIDE of the daypart object will appear as null in the API after 3:00pm Local Apparent Time.
public struct Forecast: Codable {
    /// Day of week
    public let dayOfWeek: [String]
    /// Expiration time in UNIX seconds
    public let expirationTimeUtc: [Double]
    /// Description phrase for the current lunar phase
    public let moonPhase: [String]
    /// 3 character short code for lunar phases
    public let moonPhaseCode: [MoonPhase]
    /// Day number within monthly lunar cycle
    public let moonPhaseDay: [Int]
    /// First moonrise in local time. It reflects daylight savings time conventions.
    public let moonriseTimeLocal: [String?]
    /// Moonrise time in UNIX epoch value
    public let moonriseTimeUtc: [Double?]
    /// First Moonset in local time. It reflects daylight savings time conventions.
    public let moonsetTimeLocal: [String?]
    /// Moonset time in UNIX epoch value
    public let moonsetTimeUtc: [Double?]
    /// The narrative forecast for the 24-hour period.
    public let narrative: [String]
    /// The forecasted measurable precipitation (liquid or liquid equivalent) during 12 or 24 hour period.
    public let qpf: [Double]
    /// The forecasted measurable precipitation as snow during the 12 or 24 hour forecast period.
    public let qpfSnow: [Double]
    /// The local time of the sunrise.
    /// It reflects any local daylight savings conventions.
    /// For a few Arctic and Antarctic regions, the Sunrise and Sunset data values may be the same (each with a value of 12:01am) to reflect conditions where a sunrise or sunset does not occur.
    public let sunriseTimeLocal: [String?]
    /// Sunrise time in UNIX epoch value
    public let sunriseTimeUtc: [Double?]
    /// The local time of the sunset.
    /// It reflects any local daylight savings conventions.
    /// For a few Arctic and Antarctic regions, the Sunrise and Sunset data values may be the same (each with a value of 12:01am) to reflect conditions where a sunrise or sunset does not occur.
    public let sunsetTimeLocal: [String?]
    /// Sunset time in UNIX epoch value
    public let sunsetTimeUtc: [Double?]
    /// Daily maximum temperature
    public let temperatureMax: [Double?]
    /// Daily minimum temperature
    public let temperatureMin: [Double]
    /// Time forecast is valid in UNIX seconds
    public let validTimeLocal: [String]
    /// Time forecast is valid in local apparent time.
    public let validTimeUtc: [Double]
    /// Part of days forecast.
    public let daypart: [DayPart]
}

/// Day or night indicator
public enum DayNightIndicator: String, Codable {
    /// Day
    case day = "D"
    /// Night.
    case night = "N"
}

/// Part of the days forecast.
/// For the purposes of this product day(D) = 7am to 7pm and night(N) = 7pm to 7am.
public struct DayPart: Codable {
    /// Daytime average cloud cover expressed as a percentage.
    public let cloudCover: [Double?]
    /// Day or night indicator.
    public let dayOrNight: [DayNightIndicator?]
    /// The name of a 12 hour daypart not including day names in the first 48 hours.
    public let daypartName: [String?]
    /// This number is the key to the weather icon lookup.
    /// The data field shows the icon number that is matched to represent the observed weather conditions.
    public let iconCode: [Int?]
    /// Code representing full set sensible weather.
    public let iconCodeExtend: [Int?]
    /// The narrative forecast for the daytime period.
    public let narrative: [String?]
    /// Maximum probability of precipitation.
    public let precipChance: [Double?]
    /// Type of precipitation to display with the probability of precipitation (pop) data element.
    public let precipType: [String?]
    /// The forecasted measurable precipitation (liquid or liquid equivalent) during the 12 hour forecast period.
    public let qpf: [Double?]
    /// The forecasted measurable precipitation as snow during the 12 hour forecast period.
    public let qpfSnow: [Double?]
    /// ?
    public let qualifierCode: [String?]
    /// A phrase associated to the qualifier code describing special weather criteria.
    public let qualifierPhrase: [String?]
    /// The relative humidity of the air, which is defined as the ratio of the amount of water vapor in the air to the amount of vapor required to bring the air to saturation at a constant temperature.
    /// Relative humidity is always expressed as a percentage.
    public let relativeHumidity: [Double?]
    /// Snow accumulation amount for the 12 hour forecast period.
    public let snowRange: [String?]
    /// Feels Like can move from the Heat Index and Wind Chill areas somewhat commonly.
    /// It would occur when the temperature spans across 65 F, where Heat Index is used above that value and Wind Chill is used below that value.
    public let temperature: [Double?]
    /// An apparent temperature.
    /// It represents what the air temperature “feels like” on exposed human skin due to the combined effect of warm temperatures and high humidity. 
    /// Below 65°F, it is set = to the temperature. 
    /// Units - Expressed in fahrenheit when units=e, expressed in celsius when units=m, s, or h.
    public let temperatureHeatIndex: [Double?]
    /// An apparent temperature.
    /// It represents what the air temperature “feels like” on exposed human skin due to the combined effect of the cold temperatures and wind speed.
    /// Above 65°F, it is set = to the temperature. 
    /// Units - Expressed in fahrenheit when units=e, expressed in celsius when units=m, s, or h.
    public let temperatureWindChill: [Double?]
    /// The description of probability thunderstorm activity in an area for 12 hour daypart.
    public let thunderCategory: [String?]
    /// The enumeration of thunderstorm probability within an area for a 12 hour daypart.
    /// 0 = "No thunder"; 1 = "Thunder possible"; 2 = "Thunder expected"; 3 = "Severe thunderstorms possible"; 4 = "Severe thunderstorms likely"; 5 = "High risk of severe thunderstorms"
    public let thunderIndex: [Int?]
    /// The UV Index Description which complements the UV Index value by providing an associated level of risk of skin damage due to exposure.
    public let uvDescription: [String?]
    /// Maximum UV index for the 12 hour forecast period.
    /// -2 = Not Available, -1 = No Report, 0 to 2 = Low, 3 to 5 = Moderate, 6 to 7 = High, 8 to 10 = Very High, 11 to 16 = Extreme
    public let uvIndex: [Int?]
    /// Average wind direction in magnetic notation.
    public let windDirection: [Double?]
    /// Average wind direction in cardinal notation.
    public let windDirectionCardinal: [String?]
    /// The phrase that describes the wind direction and speed for a 12 hour daypart.
    public let windPhrase: [String?]
    /// The maximum forecasted wind speed.
    /// The wind is treated as a vector; hence, winds must have direction and magnitude (speed).
    /// The wind information reported in the hourly current conditions corresponds to a 10-minute average called the sustained wind speed.
    /// Sudden or brief variations in the wind speed are known as “wind gusts” and are reported in a separate data field.
    /// Wind directions are always expressed as "from whence the wind blows" meaning that a North wind blows from North to South.
    /// If you face North in a North wind the wind is at your face.
    /// Face southward and the North wind is at your back.
    public let windSpeed: [Double?]
    /// Sensible weather phrase.
    public let wxPhraseLong: [String?]
    /// Sensible weather phrase.
    public let wxPhraseShort: [String?]
}
