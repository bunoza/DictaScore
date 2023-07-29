import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    
    @UserDefaultsWrapperCustomObject("last_played_game", defaultValue: [])
    var lastPlayedGame: [PlayerInfo]
    
    @AppStorage("last_played_game_player_number")
    var lastPlayedGamePlayerNumber: Int = 0
}

@propertyWrapper
struct UserDefaultsWrapperCustomObject<T: Codable> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults

    init(_ key: String, defaultValue: T, defaults: UserDefaults? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        userDefaults = defaults ?? .standard
    }

    var wrappedValue: T {
        get {
            guard let data = userDefaults.object(forKey: key) as? Data else {
                return defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)

            userDefaults.set(data, forKey: key)
        }
    }
}
