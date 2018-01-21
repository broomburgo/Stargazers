import UIKit

final class ModelController {
    
    let configuration: Configuration
    let loadCachedImage: RequestFunction<URL,UIImage>
    let modelRef: Ref<Application>
    
    init(configuration: Configuration, cachedLoader: (ServerConnection, (Data) -> Bool) -> RequestFunction<URL,UIImage>, initialModel: Application) {
        self.configuration = configuration
        self.loadCachedImage = cachedLoader(configuration.connection) { UIImage.init(data: $0) != nil }
        self.modelRef = Ref.init(initialModel)
    }
}
