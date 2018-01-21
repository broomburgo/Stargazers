import Foundation

extension UseCase {
    static func loadInitialStargazers(
        requestFunction: @escaping RequestFunction<RequestModel.StargazersStart,ResponseModel.Stargazers>,
        updatePage: @escaping Updater<StargazersPage>)
        -> Handler<(owner: String.NonEmpty, repo: String.NonEmpty)>
    {
        return { data in
            updatePage { $0.toLoading }
            
            requestFunction
                <| RequestModel.StargazersStart.init(owner: data.owner, repo: data.repo)
                <| handleStargazersResult(withUpdater: updatePage)
        }
    }
    
    static func appendNewStargazers(
        requestFunction: @escaping RequestFunction<RequestModel.StargazersRepo,ResponseModel.Stargazers>,
        updatePage: @escaping Updater<StargazersPage>)
        -> Handler<URL>
    {
        return  { url in
            requestFunction
                <| RequestModel.StargazersRepo.init(url: url)
                <| handleStargazersResult(withUpdater: updatePage)
        }
    }
}

// MARK: - Private

extension UseCase {
    private static func handleStargazersResult(withUpdater updatePage: @escaping Updater<StargazersPage>) -> Handler<Throwing<ResponseModel.Stargazers>> {
        return { getResult in
            do {
                let result = try getResult()

                let nextURL = (result.links?.getNext?.url)
                    .filter { $0 != result.links?.getLast?.url }
                
                let makeCell: (Stargazer) -> StargazerCell = {
                    StargazerCell.withEmptyIcon(stargazer: $0)
                }
                
                updatePage {
                    switch $0.state {

                    case .empty, .failure, .loading:
                        return $0.resetTo(
                            cells: result.stargazers.map(makeCell),
                            nextURL: nextURL)
                        
                    case .success:
                        return $0.append(
                            cells: result.stargazers.map(makeCell),
                            nextURL: nextURL)
                    }
                }
            }
            catch let error {
                updatePage { $0.fail(withError: error) }
            }
        }
    }
}
