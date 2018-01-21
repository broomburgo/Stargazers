import Foundation
import UIKit

enum Client {
    static func getResource<Input,Output>(connection: @escaping ServerConnection, getURLRequest: @escaping (Input) -> URLRequest?) -> RequestFunction<Input,Output> where Output: JSONResponseConstructible {
        return { requestModel in
            { yield in
                guard let request = getURLRequest(requestModel) else {
                    yield { throw "Cannot crate request model in configuration " }
                    return
                }
                
                print("Request: \(request)")
                
                connection
                    <| request
                    <| { serverResponse in
                        yield {
                            let jsonResponse = try JSONResponse.init(serverResponse: serverResponse)
                            print("Response: \(jsonResponse)")
                            let responseModel = try Output.init(jsonResponse: jsonResponse)
                            
                            return responseModel
                        }
                }
            }
        }
    }
    
    static func cachedLoader(connection: @escaping ServerConnection, isValidData: @escaping (Data) -> Bool) -> RequestFunction<URL,Data> {
        var cache: [URL:Data] = [:]
        
        return { url in
            { yield in
                if let cachedData = cache[url] {
                    yield { cachedData }
                    return
                }
                
                connection
                    <| URLRequest.init(url: url)
                    <| { serverResponse in
                        yield {
                            if let error = serverResponse.2 {
                                throw error
                            }
                            
                            guard let data = serverResponse.0, isValidData(data) else {
                                throw "No valid data received from server"
                            }
                            
                            cache[url] = data
                            return data
                        }
                }
            }
        }
    }
}
