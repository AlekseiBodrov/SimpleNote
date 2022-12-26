import RealmSwift
import Foundation

class Item: Object, ObjectKeyIdentifiable {
//    @Persisted var content: NSMutableAttributedString?
    @Persisted var content: String?
    @Persisted var date: String?
    @Persisted var dateCreate: Date?
}

extension Item {
    func prepareForFirstUse() -> Item {
        let item = Item()
//        item.title = "New Note".lacolized()
//        let string = "Additional text".lacolized()
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.white
//        ]
//        item.content = NSMutableAttributedString(string: string, attributes: attributes)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yy"
        item.date = formatter.string(from: date)
        return item
    }
}



/*
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
         item.title = "New Note".lacolized()
         item.content = "Additional text".lacolized()
         let date = Date()
         let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm dd.MM.yy"
         item.date = formatter.string(from: date)
         return item
     }
 }

 */
