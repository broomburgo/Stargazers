import UIKit

final class StargazerTableViewCell: UITableViewCell, XIBConstructible {
    static let cellIdentifier = "StargazerTableViewCell"
    static let cellHeight = CGFloat(60)

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func update(with model: StargazerCell) -> StargazerTableViewCell {
        self.titleLabel.text = model.title
        switch model.icon {
        case .empty:
            setImage(nil)
        case .loading:
            setLoading()
        case .failure:
            setImage(nil)
        case .success(let value):
            setImage(UIImage.init(data: value))
        }
        
        return self
    }
    
    private func setImage(_ image: UIImage?) {
        self.iconImageView.isHidden = false
        self.iconImageView.image = image
        self.activityIndicator.stopAnimating()
    }
    
    private func setLoading() {
        self.iconImageView.isHidden = true
        self.activityIndicator.startAnimating()
    }
}
