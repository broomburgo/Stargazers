import Foundation

enum Client {
    static func getResource<Input,Output>(connection: @escaping ServerConnection, getURLRequest: @escaping (Input) -> URLRequest?) -> RequestFunction<Input,Output> where Output: JSONResponseConstructible {
        return { requestModel in
            { yield in
                guard let request = getURLRequest(requestModel) else {
                    yield { throw "Cannot crate request model in configuration " }
                    return
                }
                
                connection(request) <| { serverResponse in
                    yield {
                        let jsonResponse = try JSONResponse.init(serverResponse: serverResponse)
                        let responseModel = try Output.init(jsonResponse: jsonResponse)
                        
                        return responseModel
                    }
                }
            }
        }
    }    
}

