import Foundation

extension Configuration {
    var getStartgazersStart: RequestFunction<RequestModel.StargazersStart,ResponseModel.Stargazers> {
        return Client.getResource(connection: connection) { model in
            var components = URLComponents.init()
            
            components.scheme = self.scheme
            components.host = self.host
            components.path = model.getPath
            
            guard let url = components.url else { return nil }
            
            var request = URLRequest.init(url: url)
            request.httpMethod = RequestModel.StargazersStart.method.asString
            request.allHTTPHeaderFields = self.headers
            
            return request
        }
    }
    
    var getStargazersRepo: RequestFunction<RequestModel.StargazersRepo,ResponseModel.Stargazers> {
        return Client.getResource(connection: connection) { model in
            var request = URLRequest.init(url: model.url)
            request.httpMethod = RequestModel.StargazersRepo.method.asString
            request.allHTTPHeaderFields = self.headers
            
            return request
        }
    }
}
