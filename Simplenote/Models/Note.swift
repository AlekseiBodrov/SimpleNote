import RealmSwift
import Foundation

class Item: Object {
    @Persisted var title: String?
    @Persisted var content: String?
    @Persisted var date: String?
    @Persisted var dateCreate: Date?
}

extension Item {
    func prepareForFirstUse() -> Item {
        let item = Item()

        item.title = Frase.newNote.rawValue.lacolized()
        item.content = Frase.additionalText.rawValue.lacolized()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yy"
        item.date = formatter.string(from: date)
        return item
    }
}
