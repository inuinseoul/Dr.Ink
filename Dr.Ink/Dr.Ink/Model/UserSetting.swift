//
//  UserSetting.swift
//  Dr.Ink
//
//  Created by Inwoo Park on 2022/05/16.
//

import Foundation

final class UserSetting: ObservableObject, Codable {
    static var shared = UserSetting(alarm: Alarm(time: .now, onOff: false), gender: .man, weight: 70, activity: .middle, weather: .warm)
    static let key = "UserSetting"
    
    init(alarm: Alarm, gender: Gender, weight: Int, activity: Activity, weather: Weather) {
        self.alarm = alarm
        self.gender = gender
        self.weight = weight
        self.activity = activity
        self.weather = weather
        self.challenges = []
    }
    
    static func storeInUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(UserSetting.shared)
            UserDefaults.standard.set(data, forKey: UserSetting.key)
        } catch {
            print(error)
        }
    }
    
    static func fetchFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: UserSetting.key) else { return }
        let decoder = JSONDecoder()
        do {
            let userSettring = try decoder.decode(UserSetting.self, from: data)
            UserSetting.shared.alarm = userSettring.alarm
            UserSetting.shared.gender = userSettring.gender
            UserSetting.shared.weight = userSettring.weight
            UserSetting.shared.activity = userSettring.activity
            UserSetting.shared.weather = userSettring.weather
            UserSetting.shared.challenges = userSettring.challenges
        } catch {
            print(error)
        }
    }
    
    @Published var alarm: Alarm
    @Published var gender: Gender
    @Published var weight: Int
    @Published var activity: Activity
    @Published var weather: Weather
    @Published var challenges: [Challenge]
    
    var needWater: Int {
        var water = weight * 30
        
        if activity == .low {
            water -= 300
        } else if activity == .high {
            water += 300
        }
        
        if weather == .hot {
            water += 500
        } else if weather == .warm {
            water += 300
        } else if weather == .cold {
            water -= 200
        }
        
        return water
    }
    
    enum CodingKeys: CodingKey {
        case alarm
        case gender
        case weight
        case activity
        case weather
        case challenges
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alarm = try container.decode(Alarm.self, forKey: .alarm)
        gender = try container.decode(Gender.self, forKey: .gender)
        weight = try container.decode(Int.self, forKey: .weight)
        activity = try container.decode(Activity.self, forKey: .activity)
        weather = try container.decode(Weather.self, forKey: .weather)
        challenges = try container.decode([Challenge].self, forKey: .challenges)
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alarm, forKey: .alarm)
        try container.encode(gender, forKey: .gender)
        try container.encode(weight, forKey: .weight)
        try container.encode(activity, forKey: .activity)
        try container.encode(weather, forKey: .weather)
        try container.encode(challenges, forKey: .challenges)
    }
}

struct Alarm: Codable {
    var time: Date
    var onOff: Bool
}

enum Gender: String, Codable {
    case man = "남성"
    case woman = "여성"
}

enum Activity: String, Codable {
    case low = "낮음"
    case middle = "중간"
    case high = "높음"
}

enum Weather: String, Codable {
    case hot = "더움"
    case warm = "따뜻함"
    case cool = "시원함"
    case cold = "추움"
}
