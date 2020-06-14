import Foundation

/// Retrieve measure for a Weather Underground station, using the API.
public struct WeatherGround {
    private init() {}

    /// The API key to access the Weather Underground service.
    public var apiKey: String = ""
    /// The identifier of the Personal Weather Station (PWS) to query.
    public var station: String = ""

    /// Singleton to retrieve the measures.
    public static var measure: WeatherGround = WeatherGround()

    /// Retrieve the current value of the PWS.
    ///
    /// Parameters:
    ///  - history: the current value or an error.
    public func current(history: @escaping (Result<InstantObservation, WeatherError>) -> Void) {
        guard case .success(let url) = make(for: .current) else {
            return history(.failure(.internalError))
        }
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let jsonData = data else {
                return history(.failure(.noData))
            }
            let decoder = JSONDecoder()
            do {
                let obs = try decoder.decode(WeatherObservation.self, from: jsonData)
                guard let currentObservation = obs.observations.first else {
                    return history(.failure(.formatError))
                }
                history(.success(currentObservation))
            } catch {
                history(.failure(.formatError))
            }
        }
        task.resume()
    }

    /// Retrieve the hourly measure of a day.
    ///
    /// Parameters:
    ///  - date: The date to query.
    ///  - history: The hourly observation for the day or an error.
    public func hourly(for date: Date, history: @escaping (Result<[Observation], WeatherError>) -> Void) {
        guard case .success(let url) = make(for: .hourly, with: date) else {
            return history(.failure(.internalError))
        }
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let jsonData = data else {
                return history(.failure(.noData))
            }
            let decoder = JSONDecoder()
            do {
                let obs = try decoder.decode(WeatherObservationOverview.self, from: jsonData)
                history(.success(obs.observations))
            } catch {
                return history(.failure(.formatError))
            }
        }
        task.resume()
    }

    /// Retrieve the daily average measure.
    ///
    /// Parameters:
    ///  - date: The date to query.
    ///  - history: The measure averages for the day or an error.
    public func daily(for date: Date, history: @escaping (Result<Observation, WeatherError>) -> Void) {
        guard case .success(let url) = make(for: .daily, with: date) else {
            return history(.failure(.internalError))
        }
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let jsonData = data else {
                return history(.failure(.noData))
            }
            let decoder = JSONDecoder()
            do {
                let obs = try decoder.decode(WeatherObservationOverview.self, from: jsonData)
                guard let dailyObservation = obs.observations.first else {
                    return history(.failure(.formatError))
                }
                history(.success(dailyObservation))
            } catch {
                return history(.failure(.formatError))
            }
        }
        task.resume()
    }

    /// Retrieve the 5-min history average measures.
    ///
    /// Parameters:
    ///  - date: The date to query.
    ///  - history: The measure averages for the day or an error.
    public func all(for date: Date, history: @escaping (Result<[Observation], WeatherError>) -> Void) {
        guard case .success(let url) = make(for: .all, with: date) else {
            return history(.failure(.internalError))
        }
        let task = URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard let jsonData = data else {
                return history(.failure(.noData))
            }
            let decoder = JSONDecoder()
            do {
                let obs = try decoder.decode(WeatherObservationOverview.self, from: jsonData)
                history(.success(obs.observations))
            } catch {
                return history(.failure(.formatError))
            }
        }
        task.resume()
    }

    /// Make an URL for a type of measure and a specified day.
    ///
    /// Parameters:
    ///  - type: The type of measures to retrieve.
    ///  - date: The optional date to query.
    /// Returns: The URL for the Weather Underground API to use in the query.
    private func make(for type: MeasureType, with date: Date? = nil) -> Result<URL, WeatherError> {
        guard self.station.isEmpty == false,
              self.apiKey.isEmpty == false
            else {
            return .failure(.invalidConfiguration)
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.weather.com"
        urlComponents.path = type.historyURL
        urlComponents.queryItems = [
            URLQueryItem(name: "stationId", value: self.station),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "units", value: "m"),
            URLQueryItem(name: "apiKey", value: self.apiKey)
        ]
        if let date = date {
            urlComponents.queryItems?.append(URLQueryItem(name: "date", value: date.weather))
        }

        guard let url = urlComponents.url else {
            return .failure(.internalError)
        }
        return .success(url)
    }
}
