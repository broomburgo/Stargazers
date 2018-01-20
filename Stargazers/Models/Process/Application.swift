import Foundation

struct Application {
    var stargazers: [Stargazer]
    var state: State
    
    static var empty: Application {
        return Application.init(stargazers: [], state: .empty)
    }
    
    static var loading: Application {
        return Application.init(stargazers: [], state: .loading)
    }
    
    func update(withResult model: ResponseModel.Stargazers) -> Application {
        let newStargazers = stargazers + model.stargazers
        
        let optionalNextURL = model.links?.getNext?.url
        let optionalLastURL = model.links?.getLast?.url
        
        if let nextURL = optionalNextURL, nextURL != optionalLastURL  {
            return Application.init(stargazers: newStargazers, state: .hasNextURL(nextURL))
        } else {
            return Application.init(stargazers: newStargazers, state: .done)
        }
    }
    
    func fail(withError error: Error) -> Application {
        switch state {
        case .empty, .loading, .errored, .done:
            return Application.init(stargazers: stargazers, state: .errored(error))
        case .hasNextURL(let url):
            return Application.init(stargazers: stargazers, state: .hasNextURLErrored(url, error))
        case .hasNextURLErrored(let url,_):
            return Application.init(stargazers: stargazers, state: .hasNextURLErrored(url, error))
        }
    }

    enum State {
        case empty
        case loading
        case errored(Error)
        case hasNextURL(URL)
        case hasNextURLErrored(URL,Error)
        case done
    }
}
