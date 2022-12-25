import RealmSwift

final class RealmManager {

    static let shared = RealmManager()
    private init(){}

    private let realm = try! Realm()

    func fetchData() -> Results<Item> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(Item.self)
    }

    func saveItem(with item: Item) {
        try! realm.write {
            realm.add(item)
        }
    }

    func deletItem(with item: Item) {
        try! realm.write {
            realm.delete(item)
        }
    }
}
