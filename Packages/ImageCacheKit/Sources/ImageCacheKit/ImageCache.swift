import UIKit

public final class ImageCache: @unchecked Sendable {
    public static let shared = ImageCache()

    private let cache: NSCache<NSURL, UIImage> = {
        let c = NSCache<NSURL, UIImage>()
        c.countLimit = 200
        c.totalCostLimit = 64 * 1024 * 1024
        return c
    }()

    public init() {}

    public func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    public func insert(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * 4)
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }

    public func remove(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }
}
