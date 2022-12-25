import RealmSwift
import Foundation

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var date = ""
    @objc dynamic var indexPath = 0
    @objc dynamic var icon = ""
}

extension Item {
    func prepareForFirstUse() -> Item {
        let item = Item()
        item.title = "Новая заметка"
        item.content = "Дополнительный текст"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yy"
        item.date = formatter.string(from: date)
        return item
    }
}
