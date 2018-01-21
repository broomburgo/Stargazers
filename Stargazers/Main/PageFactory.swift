import UIKit

final class PageFactory {
    
    let modelRef: Ref<(StargazersPage,[Int])>
    let configuration: Configuration
    let loadCachedImage: RequestFunction<URL,Data>
    
    init(modelRef: Ref<(StargazersPage,[Int])>, configuration: Configuration, cachedLoader: (@escaping ServerConnection, @escaping (Data) -> Bool) -> RequestFunction<URL,Data>) {
        self.modelRef = modelRef
        self.configuration = configuration
        self.loadCachedImage = cachedLoader(configuration.connection) { UIImage.init(data: $0) != nil }
    }
    
    func getStargazersViewController(tableViewAdapter: TableViewAdapter<StargazersPageCell>) -> UIViewController {
        let stargazersViewController = StargazersViewController.init(
            model: modelRef.value.0,
            tableViewAdapter: tableViewAdapter)
        
        modelRef.emitter.add(listener: "PageFactory") { [weak stargazersViewController] model, indices in
            onMainQueue {
                stargazersViewController?.updateModel(with: model, specificIndices: indices)
            }
        }
        
        stargazersViewController.actionEmitter.add(listener: "PageFactory") { [weak self] action in
            guard let this = self else { return }
            
            switch action {
                
            case .none:
                break
                
            case .search(owner: let owner, repo: let repo):
                this.search(owner: owner, repo: repo)
                
            case .nextPage(url: let url):
                this.nextPage(nextURL: url)
                
            case .loadCell(model: let model, index: let index):
                this.loadCell(stargazer: model.stargazer, index: index)
            }
        }

        return stargazersViewController
    }
}

//MARK: - Private

extension PageFactory {
    private func search(owner: String.NonEmpty, repo: String.NonEmpty) {
        (owner,repo) |> UseCase.loadInitialStargazers(
            requestFunction: configuration.getStartgazersStart,
            updatePage: { updater in
                self.modelRef.update { tuple in (updater(tuple.0),[]) }
        })
    }
    
    private func loadCell(stargazer: Stargazer, index: Int) {
        stargazer |> UseCase.loadStargazerCell(
            requestFunction: loadCachedImage,
            updateCell: { updater in
                self.modelRef.update { tuple in
                    (tuple.0.updateCell(atIndex: index, update: updater),[index])
                }
        })
    }
    
    private func nextPage(nextURL: URL) {
        nextURL |> UseCase.appendNewStargazers(
            requestFunction: configuration.getStargazersRepo,
            updatePage: { updater in
                self.modelRef.update { tuple in (updater(tuple.0),[]) }
        })
    }
}
