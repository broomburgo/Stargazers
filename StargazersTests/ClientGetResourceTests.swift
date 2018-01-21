import XCTest
@testable import Stargazers
import SwiftCheck

extension String: JSONResponseConstructible {
    public init(jsonResponse: JSONResponse) throws {
        self = ""
    }
}

struct ValidJSONMock: JSONResponseConstructible {
    let jsonResponse: JSONResponse
    init(jsonResponse: JSONResponse) throws {
        self.jsonResponse = jsonResponse
    }
}

struct InvalidJSONMock: JSONResponseConstructible {
    init(jsonResponse: JSONResponse) throws {
        throw "Invalid JSONResponse"
    }
}

class ClientGetResourceTests: XCTestCase {
    func testInvalidJSONResponseYieldsError() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,InvalidJSONMock> = Client.getResource(
                connection: { _ in pure(validServerResponse) },
                getURLRequest: { _ in URLRequest.init(url: URL.init(string: "https://www.google.it")!) })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) == nil
        }
    }

    func testValidJSONResponseYieldsSuccess() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,ValidJSONMock> = Client.getResource(
                connection: { _ in pure(validServerResponse) },
                getURLRequest: { _ in URLRequest.init(url: URL.init(string: "https://www.google.it")!) })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) != nil
        }
    }

    func testNilRequestYieldsError() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,ValidJSONMock> = Client.getResource(
                connection: { _ in pure(validServerResponse) },
                getURLRequest: { _ in nil })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) == nil
        }
    }
    
    func testInvalidServerResponseNoDataYieldsError() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,ValidJSONMock> = Client.getResource(
                connection: { _ in pure(invalidServerResponseNoData) },
                getURLRequest: { _ in URLRequest.init(url: URL.init(string: "https://www.google.it")!) })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) == nil
        }
    }
    
    func testInvalidServerResponseNoResponseYieldsError() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,ValidJSONMock> = Client.getResource(
                connection: { _ in pure(invalidServerResponseNoResponse) },
                getURLRequest: { _ in URLRequest.init(url: URL.init(string: "https://www.google.it")!) })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) == nil
        }
    }
    
    func testInvalidServerResponseErrorYieldsError() {
        property("Client.getResource with nil request results in error") <- {
            let function: RequestFunction<String,ValidJSONMock> = Client.getResource(
                connection: { _ in pure(invalidServerResponseError) },
                getURLRequest: { _ in URLRequest.init(url: URL.init(string: "https://www.google.it")!) })
            
            let throwing = runSynchronous(function(""))
            
            return (try? throwing()) == nil
        }
    }
}
