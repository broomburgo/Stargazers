import Foundation

/// The namespace for all the models related to HTTP requests
enum RequestModel {
    
    /// The model for the initial stargazers request
    struct StargazersStart {
        var owner: String.NonEmpty
        var repo: String.NonEmpty
        
        static let method = HTTPMethod.get
        
        var getPath: String {
            return "/repos/\(owner.get)/\(repo.get)/stargazers"
        }
    }
    
    /// GitHub provides the paginated requests links for the stargazers after the first owner/repo request
    struct StargazersRepo {
        var url: URL
        
        static let method = HTTPMethod.get
    }
}
