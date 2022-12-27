import RealmSwift
import UIKit

 final class OverviewListVC: UIViewController {

     //MARK: - let/var
     private enum Constants {
         static let rowHeight: CGFloat = 60
     }

     private let firstNote = Manager.firstNote
     private var notesArray: Results<Item> = Manager.notesArray

    //MARK: - IBOutlet
    @IBOutlet weak var listOfNotesTableView: UITableView!

     //MARK: - life cycle funcs
     override func viewDidLoad() {
         super.viewDidLoad()
         print(Realm.Configuration.defaultConfiguration.fileURL!)
         configure()
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         listOfNotesTableView.reloadData()
     }

     //MARK: - IBOutlet
      @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
          createViewController()
      }
 }

 //MARK: - extension TableView Delegate, DataSource
 extension OverviewListVC: UITableViewDelegate, UITableViewDataSource {

     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         deleteCell(indexPath: indexPath)
     }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         createViewController(indexPath)
     }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return Constants.rowHeight
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return notesArray.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         return createCell(tableView, for: indexPath)
     }
 }

private extension OverviewListVC {
    //MARK: - flow funcs
    func configure() {
        if notesArray.isEmpty {
            RealmManager.shared.saveItem(with: firstNote)
        }

        view.backgroundColor = .darkGray

        listOfNotesTableView.separatorColor = .darkGray
        listOfNotesTableView.backgroundColor = .darkGray
        listOfNotesTableView.delegate = self
        listOfNotesTableView.dataSource = self
        let nib = UINib(nibName: NoteTableViewCell.identifier, bundle: nil)
        listOfNotesTableView.register(nib, forCellReuseIdentifier: NoteTableViewCell.identifier)
    }

    func createViewController(_ indexPath: IndexPath? = nil) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: EditingVC.identifier) as? EditingVC else { return }
        controller.indexPath = indexPath
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func createCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }

        cell.configure(with: notesArray[indexPath.row])
        return cell
    }

    func deleteCell(indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = Frase.delete.rawValue.lacolized()
        let actionDelete = UIContextualAction(style: .destructive, title: title) { [self] _, _, _ in
            RealmManager.shared.deletItem(with: notesArray[indexPath.row])
            listOfNotesTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

extension OverviewListVC: EditingVCDelegate {
    func save() {
        listOfNotesTableView.reloadData()
    }
}
