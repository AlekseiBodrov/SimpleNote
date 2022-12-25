import RealmSwift

final class RealmManager {
    //MARK: - static var
    static let shared = RealmManager()

    //MARK: - let/var
    private let realm = try! Realm()

    //MARK: - life cycle funcs
    private init(){}

    //MARK: - flow funcs
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
