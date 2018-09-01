//
//  Created by Pierluigi Cifani on 07/05/16.
//  Copyright © 2018 TheLeftBit SL. All rights reserved.
//

import UIKit
import SDWebImage

public struct Photo {
    
    public enum Kind {
        case url(Foundation.URL)
        case image(UIImage)
        case empty
    }
    
    public let kind: Kind
    public let averageColor: UIColor
    public let size: CGSize?

    public init(kind: Kind, averageColor: UIColor = UIColor.randomColor(), size: CGSize? = nil) {
        self.kind = kind
        self.averageColor = averageColor
        self.size = size
    }

    public init(image: UIImage, averageColor: UIColor = UIColor.randomColor(), size: CGSize? = nil) {
        self.kind = .image(image)
        self.averageColor = averageColor
        self.size = size
    }

    public init(url: URL?, averageColor: UIColor = UIColor.randomColor(), size: CGSize? = nil) {
        self.kind = (url == nil) ? .empty : .url(url!)
        self.averageColor = averageColor
        self.size = size
    }
    
    public static func emptyPhoto() -> Photo {
        return Photo(kind: .empty, averageColor: RandomColorFactory.randomColor(), size: nil)
    }
}

enum RandomColorFactory {

    static var isOn: Bool = true

    static func randomColor() -> UIColor {
        guard isOn else {
            return UIColor.init(r: 255, g: 149, b: 0)
        }

        return UIColor.randomColor()
    }
}

public extension Photo {
    var estimatedSize: CGSize? {
        guard size == nil else {
            return size
        }

        return self.uiImage?.size
    }
    
    var uiImage: UIImage? {
        switch self.kind {
        case .empty:
            return nil
        case .image(let image):
            return image
        case .url(let url):
            let imageManager = SDWebImageManager.shared() //This dependency should be removed
            guard let image = imageManager.imageCache?.imageFromCache(forKey: url.absoluteString) else {
                return nil
            }
            return image
        }
    }
}

extension Photo {
    static func samplePhotos() -> [Photo] {
        let photo1 = Photo(url: URL(string: "http://e2.365dm.com/15/09/768x432/alessandro-del-piero-juventus-serie-a_3351343.jpg?20150915122301")!)
        let photo2 = Photo(url: URL(string: "http://images1.fanpop.com/images/photos/2000000/Old-Golden-Days-alessandro-del-piero-2098417-600-705.jpg")!)
        let photo3 = Photo(url: URL(string: "http://e0.365dm.com/14/05/768x432/Alessandro-del-Piero-italy-2002_3144508.jpg?20140520095830")!)
        let photo4 = Photo(url: URL(string: "http://static.goal.com/576000/576031_heroa.jpg")!)
        return [photo1, photo2, photo3, photo4]
    }
}
