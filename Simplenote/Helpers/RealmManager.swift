import RealmSwift

final class RealmManager {
    //MARK: - static var
    static let shared = RealmManager()

    //MARK: - let/var
    private lazy var realm = try! Realm()

    //MARK: - life cycle funcs
    private init(){}

    //MARK: - flow funcs
    func fetchData() -> Results<Item> {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return realm.objects(Item.self)
    }

    func saveItem(with item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch let error {
            print(error)
        }
    }

    func deletItem(with item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch let error {
            print(error)
        }
    }
}
