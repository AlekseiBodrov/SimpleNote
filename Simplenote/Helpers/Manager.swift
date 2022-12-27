import RealmSwift

class Manager {
    static var firstNote = Item().prepareForFirstUse()
    static var notesArray: (Results<Item>) = RealmManager.shared.fetchData()
}
