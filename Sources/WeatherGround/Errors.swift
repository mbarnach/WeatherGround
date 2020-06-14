/// Error types returned by the library.
public enum WeatherError: Error {
    /// An error occurs during the request preparation.
    case internalError
    /// No data are retieved.
    case noData
    /// An error occurs during the data decoding.
    case formatError
    /// The configuration is invalid: station or apikey is missing.
    case invalidConfiguration
}