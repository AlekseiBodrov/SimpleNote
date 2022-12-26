import RealmSwift
import UIKit

 final class OverviewListVC: UIViewController {

     //MARK: - let/var
     private enum Constants {
         static let rowHeight: CGFloat = 60
     }

     private let firstNote = Item().prepareForFirstUse()
     private var notesArray: Results<Item> = RealmManager.shared.fetchData()

    //MARK: - IBOutlet
    @IBOutlet weak var listOfNotesTableView: UITableView!

     //MARK: - life cycle funcs
     override func viewDidLoad() {
         super.viewDidLoad()
         configure()
     }

     //MARK: - IBOutlet
      @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
          let item = Item().prepareForFirstUse()

          RealmManager.shared.saveItem(with: item)
          createViewController()
          listOfNotesTableView.reloadData()
      }

     //MARK: - flow funcs
     private func configure() {
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

     func createViewController() {
         guard let controller = self.storyboard?.instantiateViewController(withIdentifier: EditingVC.identifier) as? EditingVC else { return }
         self.navigationController?.pushViewController(controller, animated: true)
     }

 }

 //MARK: - extension TableView Delegate, DataSource
 extension OverviewListVC: UITableViewDelegate, UITableViewDataSource {

     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let title = "Delete".lacolized()
         let actionDelete = UIContextualAction(style: .destructive, title: title) { [self] _, _, _ in
             RealmManager.shared.deletItem(with: notesArray[indexPath.row])
             listOfNotesTableView.deleteRows(at: [indexPath], with: .automatic)
         }
         let actions = UISwipeActionsConfiguration(actions: [actionDelete])
         return actions
     }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
         createViewController()
     }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return Constants.rowHeight
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return notesArray.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }

         cell.configure(with: notesArray[indexPath.row])
         return cell
     }
 }
