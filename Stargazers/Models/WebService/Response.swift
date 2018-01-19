
/// The namespace for all the models related to HTTP responses
enum ResponseModel {
    
    struct Stargazers: JSONResponseConstructible {
        var stargazers: [Stargazer]
        var links: HeaderLink?

        static let acceptedCodes = [200]
        
        init(jsonResponse: JSONResponse) throws {
            guard Stargazers.acceptedCodes.contains(jsonResponse.statusCode) else { throw "Invalid HTTP status code for Stargazers response (\(jsonResponse.statusCode)" }
            guard let jsonArray = jsonResponse.output as? [Any] else { throw "JSONResponse output is not a JSON array:\n\(jsonResponse)" }
            
            self.stargazers = jsonArray
                .flatMap { $0 as? [String:Any] }
                .flatMap { try? Stargazer.init(jsonDict: $0) }
            
            self.links = HeaderLink.init(headers: jsonResponse.headers)
        }
    }
}
