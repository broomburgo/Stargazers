import UIKit

struct Configuration {
    var scheme: String
    var host: String
    var headers: [String:String]
    var connection: ServerConnection
    
    init(scheme: String, host: String, headers: [String:String], connection: @escaping ServerConnection) {
        self.scheme = scheme
        self.host = host
        self.headers = headers
        self.connection = connection
    }
    
    static var global: Configuration {
        return  Configuration.init(
            scheme: "https",
            host: "api.github.com",
            headers: ["Accept" : "vnd.github.v3+json"],
            connection: { request in
                { handler in
                    URLSession.shared
                        .dataTask(with: request, completionHandler: handler)
                        .resume()
                }
        })
    }
}
