# WeatherGround
[![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange)](https://swift.org)
[![Swift PM Compatible](https://img.shields.io/badge/SwiftPM-Tools:5.1-FC3324.svg?style=flat)](https://swift.org/package-manager/)
[![](https://img.shields.io/badge/license-Apache-red.svg)](https://choosealicense.com/licenses/apache/)

This package is a simple wrapper around the Weather Underground API.
It provides a quick access to the current value of the Personal Weather Station (PWS),
as well as hourly, and daily history.
The features may be extended in the future if there is an interest (PR are welcome!).

To use the API, simple set the API key from Weather Underground, and specify your station like that:

```swift
WeatherGround.measure.apiKey = "1234567890af"
WeatherGround.measure.station = "station_id"
```

If you want to retrieve the current values for the station:

```swift
WeatherGround.measure.current(){ values in 
    guard case .success(let observation) = values else {
        print("Cannot retrieve the current values")
        return
    }
    print("The weather is: \(observation)")
}
```

If you need to retrieve historical values, you can use one of `hourly`, `daily` or `all`.
`hourly` and `all` returns a list of observations, whereas `daily` returns the daily average.

```swift
WeatherGround.measure.hourly(for: Date()){ history in 
    guard case .success(let observations) = history else {
        print("Unable to retrieve the observations.")
        return
    }
    print("The weather for \(Date()) was \(observations)")
}
```