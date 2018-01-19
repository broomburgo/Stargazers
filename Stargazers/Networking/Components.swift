import Foundation

/// A function representing an aynchronous request, with a possible throwing result
typealias RequestFunction<Request,Response> = (Request) -> Continuation<Throwing<Response>>

/// A simple typealias to encapsulate the tuple returned in a URLSession callback
typealias ServerResponse = (Data?, URLResponse?, Error?)

/// The basic request function, that starts from a URLRequest and returns the root response with Data?, URLResponse? and Error?
typealias ServerConnection = (URLRequest) -> Continuation<ServerResponse>
