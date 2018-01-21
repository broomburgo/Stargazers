import UIKit

extension UseCase {
    static func loadStargazerCell(
        requestFunction: @escaping RequestFunction<URL,Data>,
        updateCell: @escaping Updater<StargazerCell>)
        -> Handler<Stargazer>
    {
        return { stargazer in
            updateCell { $0.startLoadingIcon }
            
            requestFunction
                <| stargazer.avatarURL
                <| { getImage in
                    do {
                        let imageData = try getImage()
                        updateCell { $0.update(withImageData: imageData) }
                    }
                    catch let error {
                        updateCell { $0.fail(withError: error) }
                    }
            }
        }
    }
}

