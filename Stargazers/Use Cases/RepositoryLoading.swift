import Foundation

extension UseCase {
    static func loadInitialStargazers(configuration: Configuration, updateApplication: @escaping Updater<Application>) -> Handler<(owner: String.NonEmpty, repo: String.NonEmpty)> {
        return { data in
            updateApplication { _ in .loading }
            
            configuration.getStartgazersStart
                <| RequestModel.StargazersStart.init(owner: data.owner, repo: data.repo)
                <| handleStargazersResult(withUpdater: updateApplication)
        }
    }
    
    static func appendNewStargazers(configuration: Configuration, updateApplication: @escaping Updater<Application>) -> Handler<URL> {
        return  { url in
            configuration.getStargazersRepo
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
