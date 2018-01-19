import XCTest
@testable import Stargazers
import SwiftCheck

class StargazersStartTests: XCTestCase {
    
    func testCorrectPath() {
        property("Path is properly constructed") <- forAll { (model: RequestModel.StargazersStart) in
            let path = model.getPath
            return path == "/\(model.owner.get)/\(model.repo.get)/stargazers"
        }
    }
}
