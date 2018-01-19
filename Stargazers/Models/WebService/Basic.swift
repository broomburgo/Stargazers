import Foundation

/// A simple enum representing the possible http methods
enum HTTPMethod {
    case get
    
    var asString: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

/// A model of an HTTP response, that assumes a server output in JSON format
struct JSONResponse {
    var statusCode: Int
    var headers: [String:String]
    var output: Any

    init(serverResponse: ServerResponse) throws {
        if let error = serverResponse.2 { throw error }
        guard let httpResponse = serverResponse.1 as? HTTPURLResponse else { throw "No HTTPURLResponse response received in server response" }
        guard let headers = httpResponse.allHeaderFields as? [String:String] else { throw "Header are not in the correct format in http response: \(httpResponse)" }
        guard let data = serverResponse.0 else { throw "No data received in server response with http response: \(httpResponse)" }
    
        let output = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        self.statusCode = httpResponse.statusCode
        self.headers = headers
        self.output = output
    }
}

protocol JSONResponseConstructible {
    init(jsonResponse: JSONResponse) throws
}
