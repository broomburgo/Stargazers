import XCTest
@testable import Stargazers
import SwiftCheck

class JSONResponseTests: XCTestCase {
    
    func testJSONResponseThrowing() {
        property("JSONResponse yields error for wrong server response") <- forAllNoShrink(arbitraryServerResponse) { serverResponse in
            
            do {
                _ = try JSONResponse.init(serverResponse: serverResponse)
                
                return serverResponse.0 != nil
                    && serverResponse.1 != nil
                    && serverResponse.2 == nil
            }
            catch {
                return serverResponse.2 != nil
                    || serverResponse.1 == nil
                    || serverResponse.0 == nil
            }
        }
    }
    
    func testJSONResponseProperInitialization() {
        property("JSONResponse is initialized with correct data") <- forAllNoShrink(arbitraryServerResponse) { serverResponse in
            guard let jsonResponse = try? JSONResponse.init(serverResponse: serverResponse) else { return true }
            return jsonResponse.statusCode == (serverResponse.1 as! HTTPURLResponse).statusCode
                && jsonResponse.headers == (serverResponse.1 as! HTTPURLResponse).allHeaderFields as! [String:String]
        }
    }
}
