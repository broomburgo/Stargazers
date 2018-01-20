import Foundation

extension UseCase {
    static func loadInitialStargazers(
        requestFunction: @escaping RequestFunction<RequestModel.StargazersStart,ResponseModel.Stargazers>,
        updateApplication: @escaping Updater<Application>)
        -> Handler<(owner: String.NonEmpty, repo: String.NonEmpty)>
    {
        return { data in
            updateApplication { _ in .loading }
            
            requestFunction
                <| RequestModel.StargazersStart.init(owner: data.owner, repo: data.repo)
                <| handleStargazersResult(withUpdater: updateApplication)
        }
    }
    
    static func appendNewStargazers(
        requestFunction: @escaping RequestFunction<RequestModel.StargazersRepo,ResponseModel.Stargazers>,
        updateApplication: @escaping Updater<Application>)
        -> Handler<URL>
    {
        return  { url in
            requestFunction
                <| RequestModel.StargazersRepo.init(url: url)
                <| handleStargazersResult(withUpdater: updateApplication)
        }
    }
}

// MARK: - Private

extension UseCase {
    private static func handleStargazersResult(withUpdater updateApplication: @escaping Updater<Application>) -> Handler<Throwing<ResponseModel.Stargazers>> {
        return { getResult in
            do {
                let result = try getResult()
                updateApplication { $0.update(withResult: result) }
            }
            catch let error {
                updateApplication { $0.fail(withError: error) }
            }
        }
    }
}
