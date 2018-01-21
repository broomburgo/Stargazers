import UIKit

final class PageFactory {
    
    let configuration: Configuration
    let loadCachedImage: RequestFunction<URL,Data>
    
    init(configuration: Configuration, cachedLoader: (@escaping ServerConnection, @escaping (Data) -> Bool) -> RequestFunction<URL,Data>) {
        self.configuration = configuration
        self.loadCachedImage = cachedLoader(configuration.connection) { UIImage.init(data: $0) != nil }
    }
    
    func getStargazersViewController(title: String, tableViewAdapter: TableViewAdapter<StargazersPageCell>) -> UIViewController {
        let stargazersViewController = StargazersViewController.init(
            model: StargazersPage.initial(title: title),
            tableViewAdapter: tableViewAdapter)
        
        stargazersViewController.actionEmitter.add(listener: "ModelController") { [weak self, weak stargazersViewController] action in
            guard let this = self, let page = stargazersViewController else { return }
            
            switch action {
                
            case .none:
                break
                
            case .search(owner: let owner, repo: let repo):
                this.search(owner: owner, repo: repo, page: page)
                
            case .nextPage(url: let url):
                this.nextPage(nextURL: url, page: page)
                
            case .loadCell(model: let model, index: let index):
                this.loadCell(stargazer: model.stargazer, index: index, page: page)
            }
        }

        return stargazersViewController
    }
}

//MARK: - Private

extension PageFactory {
    private func search(owner: String.NonEmpty, repo: String.NonEmpty, page: StargazersViewController) {
        (owner,repo) |> UseCase.loadInitialStargazers(
            requestFunction: configuration.getStartgazersStart,
            updatePage: { updater in onMainQueue { page.updateModel(update: updater) } })
    }
    
    private func loadCell(stargazer: Stargazer, index: Int, page: StargazersViewController) {
        stargazer |> UseCase.loadStargazerCell(
            requestFunction: loadCachedImage,
            updateCell: { updater in onMainQueue { page.updateModel(
                update: { $0.updateCell(
                    atIndex: index,
                    update: updater) },
                specificIndices: [index]) }
        })
    }
    
    private func nextPage(nextURL: URL, page: StargazersViewController) {
        nextURL |> UseCase.appendNewStargazers(
            requestFunction: configuration.getStargazersRepo,
            updatePage: { updater in onMainQueue { page.updateModel(update: updater) } })
    }
}
