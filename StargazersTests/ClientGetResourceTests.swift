import XCTest
@testable import Stargazers
import SwiftCheck

extension String: JSONResponseConstructible {
    public init(jsonResponse: JSONResponse) throws {
        self = ""
    }
}

class ClientGetResourceTests: XCTestCase {
    
    func testNilRequestYieldsError() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,String> = Client.getResource(
                connection: { _ in pure(arbitraryServerResponse.generate) },
                getURLRequest: { _ in nil })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) == nil
        }
    }
}
