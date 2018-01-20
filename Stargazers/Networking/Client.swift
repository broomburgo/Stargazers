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
                
                connection
                    <| request
                    <| { serverResponse in
                        yield {
                            let jsonResponse = try JSONResponse.init(serverResponse: serverResponse)
                            let responseModel = try Output.init(jsonResponse: jsonResponse)
                            
                            return responseModel
                        }
                }
            }
        }
    }
    
    static func cachedImageLoader(connection: @escaping ServerConnection) -> RequestFunction<URL,UIImage> {
        var cache: [URL:UIImage] = [:]
        
        return { url in
            { yield in
                if let cachedImage = cache[url] {
                    yield { cachedImage }
                    return
                }
                
                connection
                    <| URLRequest.init(url: url)
                    <| { serverResponse in
                        yield {
                            if let error = serverResponse.2 {
                                throw error
                            }
                            
                            guard let data = serverResponse.0, let image = UIImage.init(data: data) else {
                                throw "Cannot create image from data"
                            }
                            
                            cache[url] = image
                            return image
                        }
                }
            }
        }
    }
}
