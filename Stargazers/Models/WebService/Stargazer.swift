import Foundation

/// Models the relevant information relative to a stargazer
struct Stargazer {
    var username: String
    var avatarURL: URL
    
    init(jsonDict: [String:Any]) throws {
        guard let username = jsonDict["login"] as? String else { throw "No string value for 'login' key in json dict:\n\(jsonDict)" }
        guard let avatarURLString = jsonDict["avatar_url"] as? String else { throw "No string value for 'avatar_url' key in json dict:\n\(jsonDict)" }
        guard let avatarURL = URL.init(string: avatarURLString) else { throw "Cannot generate avatar url from string: \(avatarURLString)" }
        
        self.username = username
        self.avatarURL = avatarURL
    }
}
