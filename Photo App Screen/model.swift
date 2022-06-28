import Foundation
import UIKit

class Model: Hashable {

    var textLabel: String
    var totalNumberOfPhotos: Int
    var photoName: String

    init(textLabel: String, totalNumberOfPhotos: Int, photoName: String) {
        self.textLabel = textLabel
        self.totalNumberOfPhotos = totalNumberOfPhotos
        self.photoName = photoName
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}
