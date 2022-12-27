import RealmSwift

class Manager {
    //MARK: - static var
    static let shared = Manager()

    //MARK: - let/var
    var firstNote = Item().prepareForFirstUse()
    var notesArray: (Results<Item>) = RealmManager.shared.fetchData()
}
